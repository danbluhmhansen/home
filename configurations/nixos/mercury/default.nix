{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
    ./hardware.nix
    inputs.niri.nixosModules.niri
  ];

  system.stateVersion = "25.05";

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  hardware = {
    graphics.enable = true;
    nvidia.open = true;
    bluetooth.enable = true;
  };

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
    greetd.settings.default_session.command = "${pkgs.lib.getExe pkgs.greetd.tuigreet} --time --remember --remember-user-session";
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

  home-manager.sharedModules = [
    ({ezModules, ...}: {
      imports = [inputs.sherlock.homeManagerModules.default ezModules.hyprland ezModules.niri ezModules.sherlock];

      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [discord gcr libnotify pavucontrol sshfs yubikey-manager];

      programs.alacritty.enable = true;
      programs.wezterm.enable = true;
      programs.firefox.enable = true;
      programs.mpv.enable = true;
      programs.yt-dlp.enable = true;
      programs.sherlock.enable = true;
      programs.swaylock.enable = true;

      programs.git.extraConfig.credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret";

      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

      services.gnome-keyring.enable = true;
      services.hyprpaper.enable = pkgs.lib.mkForce false;
      services.swaync.enable = true;
      services.wpaperd.enable = true;

      wayland.windowManager.hyprland.enable = true;
    })
  ];
}
