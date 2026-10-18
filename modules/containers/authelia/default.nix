{
  flake.modules.homeManager.authelia = {config, ...}: {
    sops.secrets.authelia = {};
    sops.secrets.autheliaJwks = {};

    services.podman.containers.authelia = {
      image = "docker.io/authelia/authelia:latest";
      environment = {
        TZ = "Europe/Copenhagen";
        X_AUTHELIA_CONFIG_FILTERS = "template";
      };
      environmentFile = [config.sops.secrets.authelia.path];
      network = ["traefik" "postgres"];
      volumes = [
        "${./configuration.yml}:/config/configuration.yml:ro"
        "${config.sops.secrets.autheliaJwks.path}:/secrets/authelia-jwks.pem:ro"
      ];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.authelia.rule" = ''Host(`auth.920301.xyz`)'';
        "traefik.http.services.authelia.loadbalancer.server.port" = "9091";
        "traefik.http.middlewares.authelia.forwardauth.address" = "http://authelia:9091/api/authz/forward-auth";
        "traefik.http.middlewares.authelia.forwardauth.trustForwardHeader" = "true";
        "traefik.http.middlewares.authelia.forwardauth.authResponseHeaders" = "Remote-User,Remote-Groups,Remote-Name,Remote-Email";
        "glance.name" = "Authelia";
        "glance.icon" = "si:authelia";
        "glance.url" = "https://auth.920301.xyz";
        "glance.description" = "'Single Sign-On Multi-Factor portal for web apps'";
      };
    };
  };
}
