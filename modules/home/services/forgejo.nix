{config, timeZone, ...}: {
  services.podman.containers.forgejo = {
    image = "codeberg.org/forgejo/forgejo:11-rootless";
    user = "1000:1000";
    environment = {
      USER_UID = "1000";
      USER_GID = "1000";
      TZ = timeZone;
    };
    network = ["traefik"];
    volumes = [
      "${config.home.homeDirectory}/srv/forgejo/data:/var/lib/gitea"
      "${config.home.homeDirectory}/srv/forgejo/conf:/etc/gitea"
    ];
    ports = ["222:2222"];
    labels = {
      "traefik.http.routers.forgejo.rule" = ''Host(`forgejo.920301.xyz`)'';
      "traefik.http.services.forgejo.loadbalancer.server.port" = "3000";
      "glance.name" = "Forgejo";
      "glance.icon" = "si:forgejo";
      "glance.url" = "https://forgejo.920301.xyz";
      "glance.description" = "Software-forge";
    };
  };
}
