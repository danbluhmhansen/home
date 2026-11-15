{
  flake.modules.nixos.attic = {
    config,
    lib,
    pkgs,
    ...
  }: {
    users.groups.atticd = {};
    users.users.atticd = {
      isSystemUser = true;
      group = "atticd";
      home = "/var/lib/atticd";
      createHome = true;
    };

    sops.secrets.atticd = {};

    services.atticd = {
      enable = true;
      user = "atticd";
      group = "atticd";
      environmentFile = config.sops.secrets.atticd.path;
      settings = {
        storage = {
          type = "local";
          path = "/srv/external-data/attic";
        };
        garbage-collection = {
          interval = "1 day";
          default-retention-period = "3 months";
        };
      };
    };

    # A real system account owns the data directory, so do not use a dynamic
    # user for the service.
    systemd.services.atticd.serviceConfig.DynamicUser = lib.mkForce false;

    systemd.services.atticd = {
      after = ["external-data-directories.service"];
      wants = ["external-data-directories.service"];
    };

    environment.systemPackages = [pkgs.attic-client];
  };
}
