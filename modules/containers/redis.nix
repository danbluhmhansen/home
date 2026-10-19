{
  flake.modules.homeManager.redis = {config, ...}: {
    services.podman.networks.redis = {
      driver = "bridge";
      subnet = "10.86.0.0/24";
    };

    services.podman.containers.redis = {
      image = "docker.io/valkey/valkey:9";
      network = ["redis"];
      autoUpdate = "registry";
      labels = {"traefik.enable" = "false";};
    };
  };
}
