{config, ...}: {
  services.podman.containers.glance = {
    image = "docker.io/glanceapp/glance:latest";
    environment = {TZ = "Europe/Copenhagen";};
    network = ["traefik"];
    volumes = [
      "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
      "${config.home.homeDirectory}/srv/glance/glance.yml:/app/config/glance.yml:ro"
    ];
    ports = ["8081:8080"];
    labels = {
      "traefik.http.routers.glance.rule" = ''Host(`glance.920301.xyz`)'';
      "traefik.http.routers.glance.middlewares" = "glance-auth";
      "traefik.http.middlewares.glance-auth.basicauth.usersfile" = "/glance-usersfile";
      "glance.name" = "Glance";
      "glance.icon" = "sh:glance";
      "glance.url" = "https://glance.920301.xyz";
      "glance.description" = "Dashboard";
    };
  };
}
