{
  flake.modules.homeManager.stalwart = {config, ...}: {
    services.podman.containers.stalwart = {
      image = "docker.io/stalwartlabs/stalwart:v0.13.2-alpine";
      environment = {TZ = "Europe/Copenhagen";};
      network = ["traefik" "postgres"];
      volumes = ["${config.home.homeDirectory}/srv/stalwart:/opt/stalwart"];
      ports = [
        "25:25"
        "110:110"
        "143:143"
        "465:465"
        "587:587"
        "993:993"
        "995:995"
        "4190:4190"
      ];
      labels = {
        "traefik.http.routers.stalwart.rule" = ''Host(`stalwart.920301.xyz`)'';
        "traefik.http.services.stalwart.loadbalancer.server.port" = "8080";
        "glance.name" = "Stalwart";
        "glance.icon" = "sh:stalwart";
        "glance.url" = "https://stalwart.920301.xyz";
        "glance.description" = "'IMAP, JMAP, SMTP, CalDAV, CardDAV, WebDAV'";
      };
    };
  };
}
