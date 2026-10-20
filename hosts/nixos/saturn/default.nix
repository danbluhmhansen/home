{
  inputs,
  config,
  ...
}: let
  specialArgs = {inherit inputs;};

  # Data directories for the containers in modules/containers/streaming.nix.
  dataDirs = builtins.map (dir: "/srv/external-data/${dir}") [
    "jellyfin"
    "ombi"
    "sonarr"
    "radarr"
    "bazarr"
    "prowlarr"
    "cleanuparr"
    "qbittorrent"
    "tvshows"
    "movies"
    "foundry"
    "downloads"
  ];
in {
  flake.nixosConfigurations.saturn = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules =
      [
        inputs.home-manager.nixosModules.home-manager
        inputs.nur.modules.nixos.default
        inputs.disko.nixosModules.default
        ({
          pkgs,
          lib,
          ...
        }: {
          networking.hostName = "saturn";
          users.users.dan.linger = true;
          networking.firewall.allowedTCPPorts = [80 443];

          backup.enable = true;

          # Boot-unlock is declared in ./_disks.nix via disko.
          #
          # systemd-tmpfiles refuses to create anything below an automount
          # point, so the data directories are created here instead. The
          # directories the containers mount are listed in dataDirs above.
          systemd.services."external-data-directories" = {
            description = "Create the data directories on the external disk";
            wantedBy = ["multi-user.target"];
            before = ["user@1000.service"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.writeShellScript "external-data-directories" ''
                set -eu

                if ${pkgs.util-linux}/bin/mountpoint -q /srv/external-data; then
                  for dir in ${lib.concatStringsSep " " dataDirs}; do
                    ${pkgs.coreutils}/bin/install -d -o dan -g users -m 0755 "$dir"
                  done
                else
                  echo "external disk is not mounted" >&2
                fi
              ''}";
            };
          };

          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                saturn

                eza
                git
                gpg
                helix
                starship
                yazi
                zellij

                actual
                authelia
                cv
                forgejo
                foundryvtt
                glance
                homeassistant
                immich
                lldap
                metube
                oxicloud
                postgres
                redis
                sparkyfitness
                streaming
                traefik
                vaultwarden
                wishlist
              ];
            };
          };
        })
        ./_disks.nix
        ./_hardware.nix
      ]
      ++ (with config.flake.modules.nixos; [
        core
        boot
        network
        fonts
        dan
        dan-sops

        nushell

        openssh
        plugdev
        podman
        sonoff-dongle

        backup
      ]);
  };
}
