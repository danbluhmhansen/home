{
  inputs,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    inputs.dms.nixosModules.greeter
    inputs.niri.nixosModules.niri
    ./disks.nix
    ./hardware.nix
  ];

  home-manager.sharedModules = [inputs.self.outputs.homeModules.mercury];

  system.stateVersion = "25.11";

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
    pam.services = {
      login.enableGnomeKeyring = true;
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
    sudo-rs.enable = true;
  };

  services = {
    openssh.enable = true;
    pcscd.enable = true;
    pipewire.enable = true;
    pipewire.alsa.enable = true;
    pipewire.pulse.enable = true;
    xserver.videoDrivers = ["nvidia"];
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="045e", MODE="0660", GROUP="plugdev", SYMLINK+="webusb"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0170", MODE="0660", GROUP="plugdev", SYMLINK+="webusb"
    '';
  };

  environment.systemPackages = with pkgs; [wayland-utils wl-clipboard xwayland-satellite];

  fonts.packages = with pkgs; [maple-mono.NF noto-fonts noto-fonts-color-emoji];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/${user}";
  };

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors.niri = {
    prettyName = "Niri";
    comment = "A scrollable-tiling Wayland compositor.";
    binPath = "/run/current-system/sw/bin/niri-session";
  };

  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;
  programs.gamescope.args = ["--adaptive-sync" "--hdr-enabled" "--rt"];
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.gamescopeSession.steamArgs = ["-tenfoot" "-pipewire-dmabuf"];
}
