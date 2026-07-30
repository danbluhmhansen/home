{
  flake.modules.homeManager.forgejo = {config, ...}: {
    sops.secrets.forgejo = {};

    services.podman.containers.forgejo = {
      image = "codeberg.org/forgejo/forgejo:16-rootless";
      user = "1000:1000";
      environment = {
        USER_UID = "1000";
        USER_GID = "1000";
        TZ = "Europe/Copenhagen";
      };
      environmentFile = [config.sops.secrets.forgejo.path];
      network = ["traefik" "postgres"];
      volumes = [
        "${config.home.homeDirectory}/srv/forgejo/data:/var/lib/gitea"
        "${config.home.homeDirectory}/srv/forgejo/conf:/etc/gitea"
      ];
      ports = ["222:2222"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.forgejo.rule" = ''Host(`forgejo.920301.xyz`)'';
        "traefik.http.services.forgejo.loadbalancer.server.port" = "3000";
        "glance.name" = "Forgejo";
        "glance.icon" = "si:forgejo";
        "glance.url" = "https://forgejo.920301.xyz";
        "glance.description" = "'Software forge'";
      };
    };
  };
}
