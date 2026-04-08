{
  inputs,
  config,
  ...
}: let
  specialArgs = {inherit inputs;};
in {
  flake.darwinConfigurations.jupiter = inputs.darwin.lib.darwinSystem {
    inherit specialArgs;
    modules =
      [
        inputs.home-manager.darwinModules.home-manager
        inputs.rosetta-builder.darwinModules.default
        {
          networking.hostName = "jupiter";
          nixpkgs.hostPlatform = "aarch64-darwin";
          system.stateVersion = 6;
          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                core
                jupiter
                dan

                firefox
                ghostty
                zed

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
        }
      ]
      ++ (with config.flake.modules.darwin; [
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

        hammerspoon
        podman
      ]);
  };
}
