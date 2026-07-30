{
  flake.modules.homeManager.sparkyfitness = {config, ...}: {
    sops.secrets.sparkyfitness = {};

    services.podman.networks.sparkyfitness = {
      driver = "bridge";
      subnet = "10.83.0.0/24";
    };

    services.podman.containers.sparkyfitness-server = {
      image = "docker.io/codewithcj/sparkyfitness_server:latest";
      environment = {
        PUID = 1000;
        GUID = 1000;
        SPARKY_FITNESS_FRONTEND_URL = "https://fitness.920301.xyz";
        SPARKY_FITNESS_DISABLE_EMAIL_LOGIN = "true";
        SPARKY_FITNESS_DB_HOST = "postgres";
        SPARKY_FITNESS_DB_NAME = "sparkyfitness";
        SPARKY_FITNESS_DB_USER = "sparkyfitness";
        SPARKY_FITNESS_APP_DB_USER = "sparkyapp";
        SPARKY_FITNESS_OIDC_AUTH_ENABLED = "true";
        SPARKY_FITNESS_OIDC_ISSUER_URL = "https://auth.920301.xyz";
        SPARKY_FITNESS_OIDC_CLIENT_ID = "sparkyfitness";
        SPARKY_FITNESS_OIDC_PROVIDER_SLUG = "authelia";
        SPARKY_FITNESS_OIDC_PROVIDER_NAME = "Authelia";
        SPARKY_FITNESS_OIDC_SCOPE = "openid email profile groups";
        SPARKY_FITNESS_OIDC_AUTO_REGISTER = "true";
        SPARKY_FITNESS_OIDC_AUTO_REDIRECT = "true";
        SPARKY_FITNESS_OIDC_TOKEN_AUTH_METHOD = "client_secret_post";
        SPARKY_FITNESS_OIDC_ID_TOKEN_SIGNED_ALG = "RS256";
        SPARKY_FITNESS_OIDC_USERINFO_SIGNED_ALG = "none";
      };
      environmentFile = [config.sops.secrets.sparkyfitness.path];
      network = ["postgres" "sparkyfitness"];
      volumes = [
        "${config.home.homeDirectory}/srv/sparkyfitness/backup:/app/SparkyFitnessServer/backup"
        "${config.home.homeDirectory}/srv/sparkyfitness/uploads:/app/SparkyFitnessServer/uploads"
      ];
      autoUpdate = "registry";
      labels = {"traefik.enable" = "false";};
    };

    services.podman.containers.sparkyfitness = {
      image = "docker.io/codewithcj/sparkyfitness:latest";
      environment = {
        PUID = 1000;
        GUID = 1000;
        SPARKY_FITNESS_FRONTEND_URL = "https://fitness.920301.xyz";
        SPARKY_FITNESS_SERVER_HOST = "sparkyfitness-server";
        SPARKY_FITNESS_SERVER_PORT = 3010;
      };
      network = ["traefik" "sparkyfitness"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.fitness.rule" = ''Host(`fitness.920301.xyz`)'';
        "traefik.http.services.fitness.loadbalancer.server.port" = "80";
        "glance.name" = "SparkyFitness";
        "glance.icon" = "sh:sparkyfitness";
        "glance.url" = "https://fitness.920301.xyz";
        "glance.description" = "'Track food, fitness, water, and health — together.'";
      };
    };
  };
}
