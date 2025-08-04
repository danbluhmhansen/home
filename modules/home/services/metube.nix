{config, ...}: {
  services.podman.containers.metube = {
    image = "ghcr.io/alexta69/metube";
    network = ["traefik"];
    volumes = ["${config.home.homeDirectory}/srv/downloads:/downloads"];
    labels = {
      "traefik.http.routers.metube.rule" = ''Host(`metube.920301.xyz`)'';
      "traefik.http.routers.metube.middlewares" = "metube-auth";
      "traefik.http.middlewares.metube-auth.basicauth.usersfile" = "/metube-usersfile";
      "traefik.http.services.metube.loadbalancer.server.port" = "8081";
      "glance.name" = "MeTube";
      "glance.icon" = "sh:metube";
      "glance.url" = "https://metube.920301.xyz";
      "glance.description" = "'YouTube downloader'";
    };
  };
}
