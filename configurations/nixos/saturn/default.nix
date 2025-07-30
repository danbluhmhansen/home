{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
    ./hardware.nix
  ];

  home-manager.sharedModules = [inputs.self.outputs.homeModules.saturn];

  system.stateVersion = "25.05";

  users.users.dan.linger = true;

  boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 0;};

  networking.firewall.allowedTCPPorts = [80 443];
  networking.networkmanager.enable = true;

  services = {
    caddy.enable = true;
    caddy.virtualHosts."bazarr.920301.xyz".extraConfig = "reverse_proxy localhost:6767";
    caddy.virtualHosts."foundry.920301.xyz".extraConfig = "reverse_proxy localhost:30000";
    caddy.virtualHosts."jf.920301.xyz".extraConfig = "reverse_proxy localhost:8096";
    caddy.virtualHosts."ombi.920301.xyz".extraConfig = "reverse_proxy localhost:3579";
    caddy.virtualHosts."prowlarr.920301.xyz".extraConfig = "reverse_proxy localhost:9696";
    caddy.virtualHosts."qb.920301.xyz".extraConfig = "reverse_proxy localhost:8080";
    caddy.virtualHosts."radarr.920301.xyz".extraConfig = "reverse_proxy localhost:7878";
    caddy.virtualHosts."sonarr.920301.xyz".extraConfig = "reverse_proxy localhost:8989";
    caddy.virtualHosts."forgejo.920301.xyz".extraConfig = "reverse_proxy localhost:3000";
    openssh.enable = true;
    tailscale.enable = true;
  };

  fonts.packages = with pkgs; [maple-mono.NF noto-fonts noto-fonts-emoji];

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
