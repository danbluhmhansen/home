{
  inputs,
  config,
  user,
  timeZone,
  ...
}: {
  imports = with inputs; [
    sops.darwinModules.sops
    rosetta-builder.darwinModules.default
    nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.config.allowUnfree = true;

  nix.channel.enable = false;
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

  time.timeZone = timeZone;

  system.primaryUser = user;
  users.users.dan.home = "/Users/${user}";

  # NOTE enable to bootstrap nix-rosetta-builder
  # nix.linux-builder = {
  #   enable = true;
  #   ephemeral = true;
  # };

  nix-rosetta-builder.onDemand = true;
  ids.gids.nixbld = 30000;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [./hammerspoon];

  nix-homebrew = {
    user = user;
    enable = true;
    enableRosetta = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  services.tailscale.enable = true;
}
