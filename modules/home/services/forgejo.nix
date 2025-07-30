{config, ...}: {
  services.podman.containers.forgejo = {
    image = "codeberg.org/forgejo/forgejo:11-rootless";
    user = "1000:1000";
    environment = {
      USER_UID = "1000";
      USER_GID = "1000";
      TZ = "Europe/Copenhagen";
    };
    network = ["traefik"];
    volumes = [
      "${config.home.homeDirectory}/srv/forgejo/data:/var/lib/gitea"
      "${config.home.homeDirectory}/srv/forgejo/conf:/etc/gitea"
    ];
    ports = ["3000:3000" "222:2222"];
    labels = {
      "glance.name" = "Forgejo";
      "glance.icon" = "si:forgejo";
      "glance.url" = "https://forgejo.920301.xyz";
      "glance.description" = ''"Software forge"'';
    };
  };
}
