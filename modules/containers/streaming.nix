{
  flake.modules.homeManager.streaming = {config, ...}: {
    services.podman.networks.streaming = {
      driver = "bridge";
      subnet = "10.81.0.0/24";
    };

    services.podman.containers.jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
        JELLYFIN_PublishedServerUrl = "https://jf.920301.xyz";
      };
      network = ["traefik" "streaming"];
      volumes = [
        "${config.home.homeDirectory}/srv/jellyfin:/config"
        "${config.home.homeDirectory}/srv/tvshows:/data/tvshows"
        "${config.home.homeDirectory}/srv/movies:/data/movies"
      ];
      ports = ["8096:8096" "7359:7359/udp" "1900:1900/udp"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.jellyfin.rule" = ''Host(`jf.920301.xyz`)'';
        "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
        "glance.name" = "Jellyfin";
        "glance.icon" = "si:jellyfin";
        "glance.url" = "https://jf.920301.xyz";
        "glance.description" = "'The Free Software Media System'";
      };
    };

    services.podman.containers.ombi = {
      image = "lscr.io/linuxserver/ombi:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
        BASE_URL = "/";
      };
      network = ["traefik" "streaming"];
      volumes = ["${config.home.homeDirectory}/srv/ombi:/config"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.ombi.rule" = ''Host(`ombi.920301.xyz`)'';
        "traefik.http.services.ombi.loadbalancer.server.port" = "3579";
        "glance.name" = "Ombi";
        "glance.icon" = "sh:ombi";
        "glance.url" = "https://ombi.920301.xyz";
        "glance.description" = "'Request tool'";
      };
    };

    services.podman.containers.sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
      };
      network = ["traefik" "streaming"];
      volumes = [
        "${config.home.homeDirectory}/srv/sonarr:/config"
        "${config.home.homeDirectory}/srv/tvshows:/data/tv"
        "${config.home.homeDirectory}/srv/downloads:/downloads"
      ];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.sonarr.rule" = ''Host(`sonarr.920301.xyz`)'';
        "traefik.http.services.sonarr.loadbalancer.server.port" = "8989";
        "glance.name" = "Sonarr";
        "glance.icon" = "si:sonarr";
        "glance.url" = "https://sonarr.920301.xyz";
        "glance.description" = "'TV show manager'";
      };
    };

    services.podman.containers.radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
      };
      network = ["traefik" "streaming"];
      volumes = [
        "${config.home.homeDirectory}/srv/radarr:/config"
        "${config.home.homeDirectory}/srv/movies:/data/movies"
        "${config.home.homeDirectory}/srv/downloads:/downloads"
      ];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.radarr.rule" = ''Host(`radarr.920301.xyz`)'';
        "traefik.http.services.radarr.loadbalancer.server.port" = "7878";
        "glance.name" = "Radarr";
        "glance.icon" = "si:radarr";
        "glance.url" = "https://radarr.920301.xyz";
        "glance.description" = "'Movie manager'";
      };
    };

    services.podman.containers.bazarr = {
      image = "lscr.io/linuxserver/bazarr:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
      };
      network = ["traefik" "streaming"];
      volumes = [
        "${config.home.homeDirectory}/srv/bazarr:/config"
        "${config.home.homeDirectory}/srv/movies:/data/movies"
        "${config.home.homeDirectory}/srv/tvshows:/data/tvshows"
      ];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.bazarr.rule" = ''Host(`bazarr.920301.xyz`)'';
        "traefik.http.services.bazarr.loadbalancer.server.port" = "6767";
        "glance.name" = "Bazarr";
        "glance.icon" = "di:bazarr";
        "glance.url" = "https://bazarr.920301.xyz";
        "glance.description" = "'Subtitle manager'";
      };
    };

    services.podman.containers.prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
      };
      network = ["traefik" "streaming"];
      volumes = ["${config.home.homeDirectory}/srv/prowlarr:/config"];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.prowlarr.rule" = ''Host(`prowlarr.920301.xyz`)'';
        "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
        "glance.name" = "Prowlarr";
        "glance.icon" = "sh:prowlarr";
        "glance.url" = "https://prowlarr.920301.xyz";
        "glance.description" = "'Index manager'";
      };
    };

    services.podman.containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      environment = {
        LOG_LEVEL = "info";
        LOG_HTML = false;
        CAPTCHA_SOLVER = "none";
        TZ = "Europe/Copenhagen";
      };
      network = ["traefik" "streaming"];
      autoUpdate = "registry";
      labels = {
        "traefik.enable" = "false";
        "glance.name" = "Flaresolverr";
        "glance.icon" = "sh:flaresolverr";
        "glance.description" = "'Proxy server to bypass Cloudflare protection'";
      };
    };

    services.podman.containers.qbittorrent = {
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Copenhagen";
        WEBUI_PORT = "8080";
        TORRENTING_PORT = "6881";
        DOCKER_MODS = "arafatamim/linuxserver-io-mod-vuetorrent";
      };
      network = ["traefik" "streaming"];
      volumes = [
        "${config.home.homeDirectory}/srv/qbittorrent:/config"
        "${config.home.homeDirectory}/srv/downloads:/downloads"
      ];
      autoUpdate = "registry";
      labels = {
        "traefik.http.routers.qbittorrent.rule" = ''Host(`qb.920301.xyz`)'';
        "traefik.http.services.qbittorrent.loadbalancer.server.port" = "8080";
        "glance.name" = "QBittorrent";
        "glance.icon" = "si:qbittorrent";
        "glance.url" = "https://qb.920301.xyz";
        "glance.description" = "'Torrent client'";
      };
    };
  };
}
