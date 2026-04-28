{
  inputs,
  config,
  lib,
  ...
}: {
  _module.args.jupiter = {includeRosettaBuilder ? true}: {
    networking.hostName = "jupiter";
    nixpkgs.hostPlatform = "aarch64-darwin";
    imports = with config.flake.modules.darwin;
      [
        inputs.home-manager.darwinModules.home-manager
        core
        dan
        homebrew

        bitwarden
        chromium
        discord
        ghostty
        obs
        signal
        steam
        zed

        nushell

        gpg
        hammerspoon
        podman
      ]
      ++ lib.optionals includeRosettaBuilder [nix-rosetta-builder];
    home-manager = {
      extraSpecialArgs.inputs = inputs;
      users.dan = {
        imports = with config.flake.modules.homeManager; [
          jupiter

          firefox

          eza
          git
          helix
          mpv
          opencode
          starship
          yazi
        ];
      };
    };
  };
}
