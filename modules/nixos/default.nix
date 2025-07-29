{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["@wheel"];
    trusted-substituters = ["https://nix-community.cachix.org"];
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  time.timeZone = "Europe/Copenhagen";

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.gpgSmartcards.enable = true;

  users.users.dan = {
    isNormalUser = true;
    createHome = true;
    home = "/home/dan";
    extraGroups = ["wheel" "networkmanager"];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
