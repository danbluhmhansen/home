{
  flake.modules.nixos.boot = {pkgs, ...}: {
    boot.initrd.systemd.enable = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
