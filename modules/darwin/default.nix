{inputs, ...}: {
  imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["@admin"];
    trusted-substituters = ["https://nix-community.cachix.org"];
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

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
}
