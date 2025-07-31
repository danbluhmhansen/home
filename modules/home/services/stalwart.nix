{config, ...}: {
  services.podman.containers.stalwart = {
    image = "docker.io/stalwartlabs/stalwart:v0.13.2-alpine";
    environment = {TZ = "Europe/Copenhagen";};
    network = ["traefik"];
    volumes = ["${config.home.homeDirectory}/srv/stalwart:/opt/stalwart"];
    ports = [
      "8082:8080"
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
      "glance.name" = "Stalwart";
      "glance.icon" = "sh:stalwart";
      "glance.url" = "https://stalwart.920301.xyz";
      "glance.description" = "IMAP,JMAP,SMTP,CalDAV,CardDAV,WebDAV";
    };
  };
}
