{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./disks.nix ./hardware.nix];

  home-manager.sharedModules = [inputs.self.outputs.homeModules.saturn];

  system.stateVersion = "25.11";

  sops.secrets.userpass.neededForUsers = true;

  users.users.dan = {
    linger = true;
    hashedPasswordFile = config.sops.secrets.userpass.path;
  };

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 0;};

  networking.firewall.allowedTCPPorts = [80 443];
  networking.networkmanager.enable = true;

  services = {
    cachix-agent.enable = true;
    openssh.enable = true;
  };

  fonts.packages = with pkgs; [maple-mono.NF noto-fonts noto-fonts-color-emoji];

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
