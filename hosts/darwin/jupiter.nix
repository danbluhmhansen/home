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
        inputs.nur.modules.darwin.default
        {
          networking.hostName = "jupiter";
          nixpkgs.hostPlatform = "aarch64-darwin";
          ids.gids.nixbld = 30000;
          home-manager = {
            extraSpecialArgs = specialArgs;
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

        nushell

        gpg
        hammerspoon
        podman
      ]);
  };
}
