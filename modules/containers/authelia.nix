{
  flake.modules.homeManager.authelia = {config, ...}: {
    sops.secrets.authelia = {};

    services.podman.containers.authelia = {
      image = "docker.io/authelia/authelia:latest";
      environmentFile = [config.sops.secrets.authelia.path];
      network = ["traefik" "postgres"];
      volumes = ["${config.home.homeDirectory}/srv/authelia:/config"];
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
