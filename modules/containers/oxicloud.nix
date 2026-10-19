{
  flake.modules.homeManager.oxicloud = {config, ...}: {
    sops.secrets.oxicloud = {};

    services.podman.containers.oxicloud = {
      image = "docker.io/diocrafts/oxicloud:latest";
      environment = {
        TZ = "Europe/Copenhagen";
        OXICLOUD_BASE_URL = "https://cloud.920301.xyz";
        OXICLOUD_DISABLE_REGISTRATION = "true";
        OXICLOUD_STORAGE_PATH = "/app/storage";
        OXICLOUD_SERVER_HOST = "0.0.0.0";
        OXICLOUD_OIDC_ENABLED = "true";
        OXICLOUD_OIDC_PROVIDER_NAME = "Authelia";
        OXICLOUD_OIDC_ISSUER_URL = "https://auth.920301.xyz";
        OXICLOUD_OIDC_CLIENT_ID = "oxicloud";
        OXICLOUD_OIDC_REDIRECT_URI = "https://cloud.920301.xyz/api/auth/oidc/callback";
        OXICLOUD_OIDC_SCOPES = "openid profile email groups";
        OXICLOUD_OIDC_FRONTEND_URL = "https://cloud.920301.xyz";
        OXICLOUD_OIDC_AUTO_PROVISION = "true";
        OXICLOUD_OIDC_ADMIN_GROUPS = "admin";
      };
      environmentFile = [config.sops.secrets.oxicloud.path];
      network = ["postgres" "traefik"];
      volumes = ["${config.home.homeDirectory}/srv/oxicloud/storage:/app/storage"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.oxicloud.rule" = ''Host(`cloud.920301.xyz`)'';
        "traefik.http.services.oxicloud.loadbalancer.server.port" = "8086";
        "glance.name" = "OxiCloud";
        "glance.icon" = "sh:oxicloud";
        "glance.url" = "https://cloud.920301.xyz";
        "glance.description" = "'Self-hosted cloud storage with WebDAV, CalDAV and CardDAV'";
      };
      extraConfig = {
        Unit.After = ["sops-nix.service"];
        Unit.Requires = ["sops-nix.service"];
      };
    };
  };
}
