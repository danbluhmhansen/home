{config, timeZone, ...}: {
  services.podman.containers.glance = {
    image = "docker.io/glanceapp/glance:latest";
    environment = {TZ = timeZone;};
    network = ["traefik"];
    volumes = [
      "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
      "${config.home.homeDirectory}/srv/glance/glance.yml:/app/config/glance.yml:ro"
    ];
    labels = {
      "traefik.http.routers.glance.rule" = ''Host(`glance.920301.xyz`)'';
      "traefik.http.routers.glance.middlewares" = "authelia@docker";
      "traefik.http.services.glance.loadbalancer.server.port" = "8080";
      "glance.name" = "Glance";
      "glance.icon" = "sh:glance";
      "glance.url" = "https://glance.920301.xyz";
      "glance.description" = "Dashboard";
    };
  };
}
