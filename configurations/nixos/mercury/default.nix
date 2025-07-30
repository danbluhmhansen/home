{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
    ./hardware.nix
    inputs.sops.nixosModules.sops
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
    inputs.self.outputs.nixosModules.pipewire
    inputs.self.outputs.nixosModules.stylix
  ];

  home-manager.sharedModules = [inputs.self.outputs.homeModules.mercury];

  system.stateVersion = "25.05";

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  sops.defaultSopsFile = "${config.users.users.dan.home}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.users.users.dan.home}/.config/sops/age/keys.txt";
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
}
