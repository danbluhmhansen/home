{
  config,
  timeZone,
  ...
}: {
  sops.secrets.foundryvtt = {};

  services.podman.containers.foundryvtt = {
    image = "docker.io/felddy/foundryvtt:13";
    environment = {
      USER_UID = "1000";
      USER_GID = "1000";
      TZ = timeZone;
    };
    environmentFile = [config.sops.secrets.foundryvtt.path];
    network = ["traefik"];
    volumes = ["${config.home.homeDirectory}/srv/foundry:/data"];
    labels = {
      "traefik.http.routers.foundryvtt.rule" = ''Host(`foundry.920301.xyz`)'';
      "traefik.http.services.foundryvtt.loadbalancer.server.port" = "30000";
      "glance.name" = "FoundryVTT";
      "glance.icon" = "si:foundryvirtualtabletop";
      "glance.url" = "https://foundry.920301.xyz";
      "glance.description" = "A-Self-Hosted-&-Modern-Roleplaying-Platform";
    };
  };
}
