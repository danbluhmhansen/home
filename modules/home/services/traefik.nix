{
  config,
  timeZone,
  ...
}: {
  sops.secrets.traefik = {};
  sops.secrets.glance = {};

  services.podman.networks.traefik = {
    driver = "bridge";
    subnet = "10.80.0.0/24";
  };

  services.podman.containers.traefik = {
    image = "docker.io/traefik:v3.5";
    environment = {TZ = timeZone;};
    network = ["traefik"];
    volumes = [
      "/run/user/1000/podman/podman.sock:/var/run/docker.sock"
      "${config.home.homeDirectory}/srv/traefik/traefik.yml:/etc/traefik/traefik.yml"
      "${config.home.homeDirectory}/srv/letsencrypt:/letsencrypt"
      "${config.sops.secrets.traefik.path}:/traefik-usersfile:ro"
      "${config.sops.secrets.glance.path}:/glance-usersfile:ro"
    ];
    ports = ["80:80" "443:443"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.dashboard.rule" = ''Host(`traefik.920301.xyz`)'';
      "traefik.http.routers.dashboard.service" = "api@internal";
      "traefik.http.routers.dashboard.middlewares" = "dashboard-auth";
      "traefik.http.middlewares.dashboard-auth.basicauth.usersfile" = "/traefik-usersfile";
      "glance.name" = "Traefik";
      "glance.icon" = "si:traefikproxy";
      "glance.url" = "https://traefik.920301.xyz";
      "glance.description" = "Proxy";
    };
  };
}
