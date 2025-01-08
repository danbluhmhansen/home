{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    inputs.disko.nixosModules.disko
  ];

  system.stateVersion = "24.05";
  networking.hostName = "saturn";
  nixpkgs.hostPlatform = "x86_64-linux";

  # TODO: Put your /etc/nixos/hardware-configuration.nix here
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/nixos";
  #   fsType = "btrfs";
  # };

  # virtualisation.vmVariantWithDisko.virtualisation.graphics = false;
  virtualisation.vmVariantWithDisko.virtualisation.fileSystems."/".neededForBoot = true;
  virtualisation.vmVariantWithDisko.virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;

  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
