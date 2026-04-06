{
  flake.modules.nixos.podman = {
    boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 0;};
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
  };
  flake.modules.darwin.podman = {homebrew.brews = ["podman"];};
  flake.modules.homeManager.podman = {pkgs, ...}: {
    home.packages = with pkgs; [podman-tui systemctl-tui];
    services.podman.enable = true;
  };
}
