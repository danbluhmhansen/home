{config, ...}: {
  sops.secrets.resume = {};

  services.podman.containers.resume = {
    image = "docker.io/amruthpillai/reactive-resume:latest";
    environment = {
      PORT = "3000";
      NODE_ENV = "production";
      # FIX PUBLIC_URL if this issue is resolved https://github.com/AmruthPillai/Reactive-Resume/issues/2153
      PUBLIC_URL = "http://resume.920301.xyz";
      STORAGE_URL = "http://minio:9000/default";
      # TODO set up chromium
      CHROME_URL = "ws://chrome:3000";
      MAIL_FROM = "noreply@920301.xyz";
      DISABLE_SIGNUPS = "true";
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
