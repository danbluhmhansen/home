{
  config,
  lib,
  pkgs,
  ...
}: {
  flake.modules.nixos.backup = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.backup;

    # The services being backed up are rootless podman containers owned by
    # this user, and the host cannot route into their network namespace.
    # `podman exec` therefore only works when the backup runs in the user's
    # own context.
    user = "dan";
    home = "/home/dan";

    mountPoint = "/srv/external-backups";
    repository = "${mountPoint}/restic";
    dumpDir = "${home}/.local/state/backup/dumps";

    podman = "${config.virtualisation.podman.package}/bin/podman";
    mountpoint = "${pkgs.util-linux}/bin/mountpoint";

    # Runs before every snapshot. The dumps land in the same snapshot as the
    # files they describe, so a restore is always a consistent pair.
    dumpScript = ''
      set -eu

      # The repository lives on an external disk that may not be attached. Bail
      # out rather than let restic create a repository on the root filesystem.
      if ! ${mountpoint} -q ${mountPoint}; then
        echo "backup: ${mountPoint} is not mounted, skipping" >&2
        exit 1
      fi

      # The repository directory is created by tmpfiles when the disk is
      # attached at boot. If the disk was attached later, it is missing.
      if [ ! -d ${repository} ]; then
        if ! mkdir -p ${repository} 2>/dev/null; then
          echo "backup: cannot create ${repository}." >&2
          echo "  Attach the backup disk, then run:" >&2
          echo "  sudo systemd-tmpfiles --create ${repository}" >&2
          exit 1
        fi
      fi

      rm -rf ${dumpDir}
      mkdir -p ${dumpDir}

      for db in ${lib.concatStringsSep " " cfg.databases}; do
        ${podman} exec postgres pg_dump -U "$db" -d "$db" -Fc -f "/tmp/$db.dump"
        ${podman} cp "postgres:/tmp/$db.dump" "${dumpDir}/$db.dump"
        ${podman} exec postgres rm -f "/tmp/$db.dump"
      done

      # Roles are not part of any database dump, but they are needed to restore.
      ${podman} exec postgres pg_dumpall -U dan --globals-only -f /tmp/globals.sql
      ${podman} cp postgres:/tmp/globals.sql ${dumpDir}/globals.sql
      ${podman} exec postgres rm -f /tmp/globals.sql

      # OxiCloud owns its storage as an internal user, so its session key is
      # not readable from here. Ask the container for it instead of skipping
      # it, and keep the original path out of the backup.
      mkdir -p ${dumpDir}/oxicloud
      if ${podman} exec oxicloud cat /app/storage/.jwt_secret > ${dumpDir}/oxicloud/.jwt_secret 2>/dev/null; then
        chmod 0600 ${dumpDir}/oxicloud/.jwt_secret
      else
        rm -f ${dumpDir}/oxicloud/.jwt_secret
      fi
    '';
  in {
    options.backup = {
      enable = lib.mkEnableOption "restic backups of service data";

      databases = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "immich"
          "oxicloud"
          "vaultwarden"
        ];
        description = "Postgres databases to dump into the backup.";
      };

      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          # Originals, thumbnails and transcoded video.
          "${home}/srv/immich/library"
          # Content addressed file data.
          "${home}/srv/oxicloud/storage"
          # The vault data is in postgres, but rsa_key.pem is what makes it
          # readable again.
          "${home}/srv/vaultwarden"
          # Encrypted with age, and the age key is not in the backup.
          "${home}/.config/sops/secrets/main.yml"
          # Logical database dumps, written by the prepare hook.
          dumpDir
        ];
        description = "Paths to back up.";
      };

      exclude = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "${home}/srv/oxicloud/storage/.dedup_temp"
          "${home}/srv/oxicloud/storage/.search-index"
          # Owned by the container's internal user, copied into the dumps
          # directory by the prepare hook instead.
          "${home}/srv/oxicloud/storage/.jwt_secret"
        ];
        description = "Patterns to exclude from the backup.";
      };

      retention = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "--keep-daily"
          "7"
          "--keep-weekly"
          "4"
          "--keep-monthly"
          "6"
        ];
        description = ''
          Options for `restic forget --prune`. Pruned photos stay in the
          repository until every snapshot referencing them has expired, so the
          oldest bucket decides how long deleted data is kept.
        '';
      };

      schedule = lib.mkOption {
        type = lib.types.str;
        default = "*-*-* 03:30:00";
        description = "When to run the backup.";
      };
    };

    config = lib.mkIf cfg.enable {
      sops.secrets.resticPassword = {
        owner = user;
        mode = "0400";
        restartUnits = ["restic-backups-data.service"];
      };

      # The disk is mounted on demand, and accessing it through tmpfiles
      # triggers the automount, so the repository is created inside the real
      # filesystem rather than in the empty directory on the root filesystem.
      systemd.tmpfiles.rules = [
        "z ${repository} 0750 ${user} users -"
      ];

      services.restic.backups.data = {
        inherit user;
        repository = repository;
        passwordFile = config.sops.secrets.resticPassword.path;
        initialize = true;

        paths = cfg.paths;
        exclude = cfg.exclude;

        backupPrepareCommand = dumpScript;
        backupCleanupCommand = "rm -rf ${dumpDir}";

        pruneOpts = cfg.retention;
        runCheck = true;

        timerConfig = {
          OnCalendar = cfg.schedule;
          RandomizedDelaySec = "1h";
          Persistent = true;
        };
      };

      # `podman exec` needs the rootless runtime directory of the backup user,
      # and podman needs HOME to find the rootless container storage.
      systemd.services."restic-backups-data".environment = {
        XDG_RUNTIME_DIR = "/run/user/1000";
        HOME = home;
      };
    };
  };
}
