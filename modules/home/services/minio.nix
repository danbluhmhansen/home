{config, ...}: {
  sops.secrets.minio = {};

  services.podman.networks.minio = {
    driver = "bridge";
    subnet = "10.83.0.0/24";
  };

  services.podman.containers.minio = {
    image = "quay.io/minio/minio:latest";
    environmentFile = [config.sops.secrets.minio.path];
    network = ["minio"];
    volumes = ["${config.home.homeDirectory}/srv/minio:/data"];
    ports = ["9000:9000" "9001:9001"];
    exec = "server /data";
    labels = {"traefik.enable" = "false";};
  };
}
