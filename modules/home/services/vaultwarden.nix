{config, ...}: {
  sops.secrets.vaultwarden = {};

  services.podman.containers.vaultwarden = {
    image = "docker.io/timshel/oidcwarden:latest-alpine";
    environment = {
      DOMAIN = "https://vault.920301.xyz";
      SIGNUPS_ALLOWED = "false";
    };
    environmentFile = [config.sops.secrets.vaultwarden.path];
    network = ["traefik" "postgres"];
    volumes = ["${config.home.homeDirectory}/srv/vaultwarden:/data"];
    labels = {
      "traefik.http.routers.vaultwarden.rule" = ''Host(`vault.920301.xyz`)'';
      "traefik.http.services.vaultwarden.loadbalancer.server.port" = "80";
      "glance.name" = "Vaultwarden";
      "glance.icon" = "si:vaultwarden";
      "glance.url" = "https://vault.920301.xyz";
      "glance.description" = "'Unofficial Bitwarden compatible server'";
    };
  };
}
