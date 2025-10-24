{
  config,
  timeZone,
  ...
}: {
  sops.secrets.gameyfin = {};

  services.podman.containers.gameyfin = {
    image = "ghcr.io/gameyfin/gameyfin:2";
    environmentFile = [config.sops.secrets.gameyfin.path];
    environment = {
      TZ = timeZone;
      APP_URL = "https://gf.920301.xyz";
      PUID = "1000";
      PGID = "1000";
    };
    network = ["traefik"];
    volumes = [
      "${config.home.homeDirectory}/srv/gameyfin/db:/opt/gameyfin/db"
      "${config.home.homeDirectory}/srv/gameyfin/data:/opt/gameyfin/data"
      "${config.home.homeDirectory}/srv/gameyfin/logs:/opt/gameyfin/logs"
    ];
    labels = {
      "traefik.http.routers.gameyfin.rule" = ''Host(`gf.920301.xyz`)'';
      "traefik.http.services.gameyfin.loadbalancer.server.port" = "8080";
      "glance.name" = "gameyfin";
      "glance.icon" = "sh:gameyfin";
      "glance.url" = "https://gf.920301.xyz";
      "glance.description" = "Manage your video games";
    };
  };
}
