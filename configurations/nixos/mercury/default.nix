{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = with inputs.self.outputs.nixosModules; [
    inputs.niri.nixosModules.niri
    ./disks.nix
    ./hardware.nix
    pipewire
    stylix
  ];

  home-manager.sharedModules = [inputs.self.outputs.homeModules.mercury];

  system.stateVersion = "25.05";

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  sops.secrets.userpass.neededForUsers = true;

  users.users.dan.hashedPasswordFile = config.sops.secrets.userpass.path;
  users.groups.plugdev = {};
  users.users.dan.extraGroups = ["plugdev"];

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    graphics.enable = true;
    nvidia.open = true;
    bluetooth.enable = true;
  };

  networking.networkmanager.enable = true;

  security = {
    doas.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      login.kwallet.enable = true;
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
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
      pkg = pkgs.lib.getExe pkgs.tuigreet;
    in "${pkg} --time --remember --remember-user-session";
    greetd.settings.default_session.user = "greeter";
    desktopManager.plasma6.enable = true;
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="045e", MODE="0660", GROUP="plugdev", SYMLINK+="webusb"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0170", MODE="0660", GROUP="plugdev", SYMLINK+="webusb"
    '';
  };

  environment.systemPackages = with pkgs; [wayland-utils wl-clipboard xwayland-satellite];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    ark
    dolphin
    elisa
    gwenview
    kate
    kinfocenter
    konsole
    ksystemstats
    okular
  ];

  fonts.packages = with pkgs; [maple-mono.NF noto-fonts noto-fonts-emoji];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors.niri = {
    prettyName = "Niri";
    comment = "A scrollable-tiling Wayland compositor.";
    binPath = "/run/current-system/sw/bin/niri-session";
  };

  programs.gamescope.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.gamescopeSession.args = ["--adaptive-sync" "--hdr-enabled"];

  stylix.enable = true;

  qt.platformTheme = pkgs.lib.mkForce "kde";
}
