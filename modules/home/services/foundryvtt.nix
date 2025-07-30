{config, ...}: {
  services.podman.containers.foundryvtt = {
    image = "docker.io/felddy/foundryvtt:13";
    environment = {
      USER_UID = "1000";
      USER_GID = "1000";
      TZ = "Europe/Copenhagen";
    };
    environmentFile = [config.sops.secrets.foundryvtt.path];
    network = ["traefik"];
    volumes = ["${config.home.homeDirectory}/srv/foundry:/data"];
    ports = ["30000:30000"];
    labels = {
      "glance.name" = "FoundryVTT";
      "glance.icon" = "si:foundryvirtualtabletop";
      "glance.url" = "https://foundry.920301.xyz";
      "glance.description" = ''"A Self-Hosted & Modern Roleplaying Platform"'';
    };
  };
}
