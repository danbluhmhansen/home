{
  inputs,
  config,
  pkgs,
  ezModules,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
    ./hardware.nix
    inputs.sops.nixosModules.sops
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
    ezModules.pipewire
    ezModules.stylix
  ];

  system.stateVersion = "25.05";

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  sops.defaultSopsFile = "/home/dan/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "/home/dan/.config/sops/age/keys.txt";
  sops.age.generateKey = true;

  sops.secrets.userpass.neededForUsers = true;

  users.users.dan = {
    hashedPasswordFile = config.sops.secrets.userpass.path;
    linger = true;
  };

  boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 0;};

  hardware = {
    graphics.enable = true;
    nvidia.open = true;
    bluetooth.enable = true;
  };

  networking.firewall.allowedTCPPorts = [80 443];
  networking.networkmanager.enable = true;

  security = {
    doas.enable = true;
    pam.services.identity.enableGnomeKeyring = true;
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
    pipewire.enable = true;
    xserver.videoDrivers = ["nvidia"];
    greetd.enable = true;
    greetd.settings.default_session.command = let
      pkg = pkgs.lib.getExe pkgs.greetd.tuigreet;
    in "${pkg} --time --remember --remember-user-session";
    greetd.settings.default_session.user = "greeter";
    tailscale.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wayland-utils
    wl-clipboard
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [maple-mono.NF noto-fonts noto-fonts-emoji];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  programs.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  programs.hyprland.withUWSM = true;
  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors.niri = {
    prettyName = "Niri";
    comment = "A scrollable-tiling Wayland compositor.";
    binPath = "/run/current-system/sw/bin/niri-session";
  };

  programs.gamescope.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  stylix.enable = true;

  virtualisation.containers.enable = true;
  virtualisation.containers.storage.settings.storage = {
    driver = "btrfs";
    runroot = "/run/containers/storage";
    graphroot = "/var/lib/containers/storage";
    options.overlay.mountopt = "nodev,metacopy=on";
  };
  virtualisation.oci-containers.backend = "podman";
  virtualisation.podman.enable = true;
  virtualisation.podman = {
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  home-manager.sharedModules = [
    ({
      config,
      ezModules,
      ...
    }: {
      imports = [inputs.sherlock.homeManagerModules.default ezModules.hyprland ezModules.niri ezModules.sherlock];

      sops.defaultSopsFile = "/home/dan/.config/sops/secrets/main.yml";
      sops.validateSopsFiles = false;
      sops.age.keyFile = "/home/dan/.config/sops/age/keys.txt";
      sops.age.generateKey = true;

      sops.secrets.foundryvtt = {};

      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        discord
        gcr
        libnotify
        pavucontrol
        podman-tui
        sshfs
        systemctl-tui
        yubikey-manager
      ];

      programs.alacritty.enable = true;
      programs.wezterm.enable = true;
      programs.firefox.enable = true;
      programs.mpv.enable = true;
      programs.yt-dlp.enable = true;
      programs.sherlock.enable = true;
      programs.swaylock.enable = true;

      programs.git.extraConfig.credential.helper = let
        pkg = pkgs.git.override {withLibsecret = true;};
      in "${pkg}/bin/git-credential-libsecret";

      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

      services.gnome-keyring.enable = true;
      services.hyprpaper.enable = pkgs.lib.mkForce false;
      services.swaync.enable = true;
      services.wpaperd.enable = true;

      services.podman.enable = true;

      services.podman.networks.traefik = {
        driver = "bridge";
        subnet = "10.80.0.0/24";
      };
      services.podman.networks.streaming = {
        driver = "bridge";
        subnet = "10.81.0.0/24";
      };

      services.podman.containers.glance = {
        image = "docker.io/glanceapp/glance:latest";
        environment = {TZ = "Europe/Copenhagen";};
        network = ["traefik"];
        volumes = [
          "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
          "${config.home.homeDirectory}/srv/glance/glance.yml:/app/config/glance.yml:ro"
        ];
        labels = {
          "glance.name" = "Glance";
          "glance.icon" = "sh:glance";
          "glance.url" = "https://glance.920301.xyz";
          "glance.description" = ''"Dashboard"'';
        };
      };

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

      services.podman.containers.foundryvtt = {
        image = "docker.io/felddy/foundryvtt:13";
        environment = {
          USER_UID = "1000";
          USER_GID = "1000";
          TZ = "Europe/Copenhagen";
        };
        environmentFile = [config.sops.secrets.foundryvtt.path];
        network = ["traefik"];
        volumes = ["${config.home.homeDirectory}/srv/foundry:/data"];
        ports = ["30000:30000"];
        labels = {
          "glance.name" = "FoundryVTT";
          "glance.icon" = "si:foundryvirtualtabletop";
          "glance.url" = "https://foundry.920301.xyz";
          "glance.description" = ''"A Self-Hosted & Modern Roleplaying Platform"'';
        };
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
        labels = {
          "glance.name" = "Jellyfin";
          "glance.icon" = "si:jellyfin";
          "glance.url" = "https://jf.920301.xyz";
          "glance.description" = ''"The Free Software Media System"'';
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
        ports = ["3579:3579"];
        labels = {
          "glance.name" = "Ombi";
          "glance.icon" = "sh:ombi";
          "glance.url" = "https://ombi.920301.xyz";
          "glance.description" = ''"Request tool"'';
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
        ports = ["8989:8989"];
        labels = {
          "glance.name" = "Sonarr";
          "glance.icon" = "si:sonarr";
          "glance.url" = "https://sonarr.920301.xyz";
          "glance.description" = ''"TV show manager"'';
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
        ports = ["7878:7878"];
        labels = {
          "glance.name" = "Radarr";
          "glance.icon" = "si:radarr";
          "glance.url" = "https://radarr.920301.xyz";
          "glance.description" = ''"Movie manager"'';
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
        ports = ["6767:6767"];
        labels = {
          "glance.name" = "Bazarr";
          "glance.icon" = "sh:bazarr";
          "glance.url" = "https://bazarr.920301.xyz";
          "glance.description" = ''"Subtitle manager"'';
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
        ports = ["9696:9696"];
        labels = {
          "glance.name" = "Prowlarr";
          "glance.icon" = "sh:prowlarr";
          "glance.url" = "https://prowlarr.920301.xyz";
          "glance.description" = ''"Index manager"'';
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
        ports = ["8191:8191"];
        labels = {
          "glance.name" = "Flaresolverr";
          "glance.icon" = "sh:flaresolverr";
          "glance.url" = "https://flaresolverr.920301.xyz";
          "glance.description" = ''"Proxy server to bypass Cloudflare protection"'';
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
        ports = [
          "8080:8080"
          "6881:6881"
          "6881:6881/udp"
        ];
        labels = {
          "glance.name" = "QBittorrent";
          "glance.icon" = "si:qbittorrent";
          "glance.url" = "https://qb.920301.xyz";
          "glance.description" = ''"Torrent client"'';
        };
      };

      systemd.user.mounts.home-dan-saturn = {
        Unit.After = ["network-online.target"];
        Unit.Wants = ["network-online.target"];
        Install.WantedBy = ["default.target"];
        Mount.What = "saturn:/home/dan";
        Mount.Where = "${config.home.homeDirectory}/saturn";
        Mount.Type = "fuse.sshfs";
      };
      systemd.user.automounts.home-dan-saturn = {
        Install.WantedBy = ["default.target"];
        Automount.Where = "${config.home.homeDirectory}/saturn";
      };

      systemd.user.mounts.home-dan-glbe9300 = {
        Unit.After = ["network-online.target"];
        Unit.Wants = ["network-online.target"];
        Install.WantedBy = ["default.target"];
        Mount.What = "gl-be9300:/";
        Mount.Where = "${config.home.homeDirectory}/glbe9300";
        Mount.Type = "fuse.sshfs";
      };
      systemd.user.automounts.home-dan-glbe9300 = {
        Install.WantedBy = ["default.target"];
        Automount.Where = "${config.home.homeDirectory}/glbe9300";
      };

      wayland.windowManager.hyprland.enable = true;
    })
  ];
}
