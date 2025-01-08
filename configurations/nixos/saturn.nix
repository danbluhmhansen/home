{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [self.nixosModules.default];

  system.stateVersion = "24.05";
  networking.hostName = "saturn";
  nixpkgs.hostPlatform = "x86_64-linux";

  # TODO: Put your /etc/nixos/hardware-configuration.nix here
  boot.loader.grub.device = "nodev";
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
  };
  virtualisation.vmVariant.virtualisation.graphics = false;
  virtualisation.vmVariant.virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
}
