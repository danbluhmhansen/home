{
  flake.modules.homeManager.foundryvtt = {config, ...}: {
    sops.secrets.foundryvtt = {};

    services.podman.containers.foundryvtt = {
      image = "docker.io/felddy/foundryvtt:14";
      environment = {
        USER_UID = "1000";
        USER_GID = "1000";
        TZ = "Europe/Copenhagen";
        FOUNDRY_HOSTNAME = "foundry.920301.xyz";
        FOUNDRY_MINIFY_STATIC_FILES = "true";
        FOUNDRY_PROXY_SSL = "true";
        FOUNDRY_PROXY_PORT = "443";
      };
      environmentFile = [config.sops.secrets.foundryvtt.path];
      network = ["traefik"];
      volumes = [
        "${config.home.homeDirectory}/srv/foundry:/data"
        "${config.home.homeDirectory}/srv/downloads:/data/Data/assets/downloads"
      ];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.foundryvtt.rule" = ''Host(`foundry.920301.xyz`)'';
        "traefik.http.routers.foundryvtt.middlewares" = "authelia@docker";
        "traefik.http.services.foundryvtt.loadbalancer.server.port" = "30000";
        "glance.name" = "FoundryVTT";
        "glance.icon" = "si:foundryvirtualtabletop";
        "glance.url" = "https://foundry.920301.xyz";
        "glance.description" = "'A Self Hosted & Modern Roleplaying Platform'";
      };
    };
  };
}
