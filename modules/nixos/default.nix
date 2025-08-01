{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.sops.nixosModules.sops];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["@wheel"];
    trusted-substituters = ["https://nix-community.cachix.org" "https://danbluhmhansen.cachix.org"];
    extra-substituters = ["https://nix-community.cachix.org" "https://danbluhmhansen.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "danbluhmhansen.cachix.org-1:0qTEsQt253LH3OJC7oxZSjSIf+6vB+l2scs1r+DnM+I="
    ];
  };

  sops.defaultSopsFile = "${config.users.users.dan.home}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.users.users.dan.home}/.config/sops/age/keys.txt";
  sops.age.generateKey = true;

  sops.secrets.userpass.neededForUsers = true;

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
    hashedPasswordFile = config.sops.secrets.userpass.path;
    extraGroups = ["wheel" "networkmanager"];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
