{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sherlock.homeManagerModules.default
    inputs.self.outputs.homeModules.hyprland
    inputs.self.outputs.homeModules.niri
    inputs.self.outputs.homeModules.sherlock
    ./services/forgejo.nix
    ./services/foundryvtt.nix
    ./services/streaming.nix
  ];

  sops.defaultSopsFile = "${config.home.homeDirectory}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
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
  services.swww.enable = true;

  services.podman.enable = true;

  services.podman.networks.traefik = {
    driver = "bridge";
    subnet = "10.80.0.0/24";
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
}
