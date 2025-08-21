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
    ports = ["9000:9000"];
    exec = ''server /data --console-address=":9001"'';
    labels = {
      "traefik.http.routers.minio.rule" = ''Host(`minio.920301.xyz`)'';
      "traefik.http.services.minio.loadbalancer.server.port" = "9001";
      "glance.name" = "MinIO";
      "glance.icon" = "sh:minio";
      "glance.url" = "https://minio.920301.xyz";
      "glance.description" = "'S3 compatible object store'";
    };
  };
}
