{
  flake.modules.homeManager.actual = {config, ...}: {
    services.podman.containers.actual = {
      image = "docker.io/actualbudget/actual-server:latest";
      network = ["traefik"];
      volumes = ["${config.home.homeDirectory}/srv/actual:/data"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.actual.rule" = ''Host(`actual.920301.xyz`)'';
        "traefik.http.services.actual.loadbalancer.server.port" = "5006";
        "glance.name" = "Actual Budget";
        "glance.icon" = "si:actualbudget";
        "glance.url" = "https://actual.920301.xyz";
        "glance.description" = "'Personal finance'";
      };
    };
  };
}
