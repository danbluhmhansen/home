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

        gpg
        hammerspoon
        podman
      ]
      ++ lib.optionals includeRosettaBuilder [nix-rosetta-builder];
    home-manager = {
      extraSpecialArgs.inputs = inputs;
      users.dan = {
        imports = with config.flake.modules.homeManager; [
          core
          jupiter
          dan

          firefox
          ghostty
          zed

          eza
          git
          gpg
          helix
          mpv
          opencode
          starship
          yazi

          hammerspoon
        ];
      };
    };
  };
}
