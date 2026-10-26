{
  flake.modules.homeManager.homeassistant = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # The OpenID Connect authentication provider for Home Assistant. It is a
    # custom component, so it is installed into the configuration directory.
    # Home Assistant itself no longer ships an OIDC provider, see
    # https://github.com/christiaangoossens/hass-oidc-auth
    #
    # Pinned to a release, whose assets are immutable. The sha256 of the
    # release asset is e5badaaacaa63cfd6fe733924a05e76d75058836190398598fb24de57cd47ccd.
    authOidc = pkgs.fetchzip {
      url = "https://github.com/christiaangoossens/hass-oidc-auth/releases/download/v1.2.1/hass-oidc-auth.zip";
      hash = "sha256-zrOc7cRcME7v7dy4d+6kSyALdyKx+3LjetOc/cauN1c=";
      # The archive holds the files of the component, not a directory.
      stripRoot = false;
    };
  in {
    # Podman does not create the source of a bind mount that does not exist,
    # so the configuration directory is created here.
    home.activation.homeassistantConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p "$HOME/srv/homeassistant"
    '';

    # The integration is unpacked into the configuration directory. The
    # directory is not removed first: some files in it are owned by the
    # container's (rootless) root user and cannot be deleted by the user
    # running the activation, so the contents are just overwritten in place.
    home.activation.homeassistantAuthOidc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p "$HOME/srv/homeassistant/custom_components/auth_oidc"
      run cp -R ${authOidc}/. "$HOME/srv/homeassistant/custom_components/auth_oidc/"
    '';

    services.podman.containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      environment = {
        TZ = "Europe/Copenhagen";
      };
      # Host networking so that Home Assistant can discover Thread border
      # routers (such as the HomePod Mini) over mDNS on the LAN. Traefik
      # reaches the container through the file provider in the traefik module
      # (see modules/containers/traefik/dynamic/ha.yml).
      network = ["host"];
      # The SONOFF Dongle Max is attached over USB and is used by the ZHA
      # integration. It is passed in as /dev/ttyUSB0, which is where Home
      # Assistant looks for USB radios.
      devices = ["/dev/sonoff-dongle-m:/dev/ttyUSB0"];
      volumes = ["${config.home.homeDirectory}/srv/homeassistant:/config"];
      autoUpdate = "registry";
      labels = {
        # Home Assistant authenticates its own users through Authelia with
        # OIDC, so it is not behind the forward authentication middleware.
        "glance.name" = "Home Assistant";
        "glance.icon" = "mdi:home-assistant";
        "glance.url" = "https://ha.920301.xyz";
        "glance.description" = "Home automation";
      };
    };
  };
}
