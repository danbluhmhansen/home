{
  flake.modules.homeManager.immich = {config, ...}: {
    sops.secrets.immich = {};

    services.podman.networks.immich = {
      driver = "bridge";
      subnet = "10.84.0.0/24";
    };

    services.podman.containers.immich-server = {
      image = "ghcr.io/immich-app/immich-server:release";
      environment = {
        TZ = "Europe/Copenhagen";
        # Face detection, smart search and OCR need the machine learning
        # container, which is not deployed. Re-enable it there and drop this.
        IMMICH_MACHINE_LEARNING_ENABLED = "false";
        DB_HOSTNAME = "postgres";
        DB_USERNAME = "immich";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "redis";
      };
      environmentFile = [config.sops.secrets.immich.path];
      network = ["immich" "postgres" "redis" "traefik"];
      volumes = ["${config.home.homeDirectory}/srv/immich/library:/data"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.immich.rule" = ''Host(`immich.920301.xyz`)'';
        "traefik.http.services.immich.loadbalancer.server.port" = "2283";
        "glance.name" = "Immich";
        "glance.icon" = "sh:immich";
        "glance.url" = "https://immich.920301.xyz";
        "glance.description" = "'Self-hosted photo and video management'";
      };
      extraConfig = {
        Unit.After = ["sops-nix.service"];
        Unit.Requires = ["sops-nix.service"];
      };
    };
  };
}
