{config, ...}: {
  sops.secrets.resume = {};

  services.podman.containers.resume = {
    image = "docker.io/amruthpillai/reactive-resume:latest";
    environment = {
      PORT = "3000";
      NODE_ENV = "production";
      PUBLIC_URL = "https://resume.920301.xyz";
      MAIL_FROM = "noreply@920301.xyz";
      DISABLE_SIGNUPS = "false";
      DISABLE_EMAIL_AUTH = "false";
    };
    environmentFile = [config.sops.secrets.resume.path];
    network = ["traefik" "postgres" "minio"];
    labels = {
      "traefik.http.routers.resume.rule" = ''Host(`resume.920301.xyz`)'';
      "traefik.http.services.resume.loadbalancer.server.port" = "3000";
      "glance.name" = "Reactive-Resume";
      "glance.icon" = "si:reactiveresume";
      "glance.url" = "https://resume.920301.xyz";
      "glance.description" = "'Resume builder'";
    };
  };
}
