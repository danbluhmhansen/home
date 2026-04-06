{inputs, ...}: {
  flake.modules.darwin.homebrew = {config, ...}: {
    imports = [inputs.homebrew.darwinModules.nix-homebrew];
    homebrew.enable = true;
    homebrew.onActivation.cleanup = "zap";
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
    };
    homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
  };
  flake.modules.darwin.dan = {nix-homebrew.user = "dan";};
}
