{config, ...}: {
  sops.secrets.postgres = {};
  sops.secrets.psqlInitScript = {};

  services.podman.networks.postgres = {
    driver = "bridge";
    subnet = "10.82.0.0/24";
  };

  services.podman.containers.postgres = {
    image = "docker.io/postgres:17-alpine";
    environmentFile = [config.sops.secrets.postgres.path];
    network = ["postgres"];
    volumes = [
      "${config.home.homeDirectory}/srv/postgres:/var/lib/postgresql/data"
      "${config.sops.secrets.psqlInitScript.path}:/docker-entrypoint-initdb.d/init.sql"
    ];
    ports = ["5432:5432"];
    labels = {"traefik.enable" = "false";};
  };
}
