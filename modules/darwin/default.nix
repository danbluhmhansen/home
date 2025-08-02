{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops.darwinModules.sops
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["@admin"];
    trusted-substituters = ["https://nix-community.cachix.org" "https://danbluhmhansen.cachix.org"];
    extra-substituters = ["https://nix-community.cachix.org" "https://danbluhmhansen.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "danbluhmhansen.cachix.org-1:0qTEsQt253LH3OJC7oxZSjSIf+6vB+l2scs1r+DnM+I="
    ];
  };

  sops.defaultSopsFile = "${config.users.users.dan.home}/Library/Application Support/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.users.users.dan.home}/Library/Application Support/sops/age/keys.txt";
  sops.age.generateKey = true;

  time.timeZone = "Europe/Copenhagen";

  system.primaryUser = "dan";
  users.users.dan.home = "/Users/dan";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [./hammerspoon];

  nix-homebrew = {
    user = "dan";
    enable = true;
    enableRosetta = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  services.tailscale.enable = true;
}
