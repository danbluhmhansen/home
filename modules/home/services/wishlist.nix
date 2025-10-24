{
  config,
  timeZone,
  ...
}: {
  services.podman.containers.wishlist = {
    image = "ghcr.io/cmintey/wishlist:latest";
    environment = {
      TZ = timeZone;
      ORIGIN = "https://wish.920301.xyz";
    };
    network = ["traefik"];
    volumes = [
      "${config.home.homeDirectory}/srv/wishlist:/usr/src/app/data"
      "${config.home.homeDirectory}/srv/uploads:/usr/src/app/uploads"
    ];
    labels = {
      "traefik.http.routers.wishlist.rule" = ''Host(`wish.920301.xyz`)'';
      "traefik.http.services.wishlist.loadbalancer.server.port" = "3280";
      "glance.name" = "Wishlist";
      "glance.icon" = "sh:cmintey-wishlist";
      "glance.url" = "https://wish.920301.xyz";
      "glance.description" = "Wishlist";
    };
  };
}
