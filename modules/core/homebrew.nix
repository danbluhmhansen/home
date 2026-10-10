{inputs, ...}: {
  flake.modules.darwin.homebrew = {config, ...}: {
    imports = [inputs.homebrew.darwinModules.nix-homebrew];
    homebrew = {
      enable = true;
      global.brewfile = true;
      onActivation = {cleanup = "zap";};
      taps = builtins.attrNames config.nix-homebrew.taps;
    };
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
    };
  };
  flake.modules.darwin.dan = {nix-homebrew.user = "dan";};
}
