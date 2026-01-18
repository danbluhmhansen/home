{
  inputs,
  config,
  pkgs,
  user,
  timeZone,
  ...
}: {
  imports = with inputs; [
    disko.nixosModules.disko
    sops.nixosModules.sops
    stylix.nixosModules.stylix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["@wheel"];
    trusted-substituters = ["https://nix-community.cachix.org" "https://danbluhmhansen.cachix.org"];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://danbluhmhansen.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "danbluhmhansen.cachix.org-1:0qTEsQt253LH3OJC7oxZSjSIf+6vB+l2scs1r+DnM+I="
    ];
  };

  sops.defaultSopsFile = "${config.users.users.dan.home}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.users.users.dan.home}/.config/sops/age/keys.txt";
  sops.age.generateKey = true;

  time.timeZone = timeZone;

  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings.LC_ALL = "en_DK.UTF-8";

  hardware.gpgSmartcards.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.dan = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${user}";
    extraGroups = ["wheel" "networkmanager"];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  programs.zsh.enable = true;

  services.tailscale.enable = true;
}
