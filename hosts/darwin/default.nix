{
  inputs,
  config,
  ...
}: let
  specialArgs = {inherit inputs;};
in {
  flake.darwinConfigurations = {
    jupiter = inputs.darwin.lib.darwinSystem {
      inherit specialArgs;
      modules =
        [
          inputs.home-manager.darwinModules.home-manager
          {
            networking.hostName = "jupiter";
            nixpkgs.hostPlatform = "aarch64-darwin";
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
          }
        ]
        ++ (with config.flake.modules.darwin; [
          core
          dan
          nix-rosetta-builder
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
        ]);
    };
    # NOTE: This is a clone of the `jupiter` config to be able to build without `nix-rosetta-builder` which requires
    # bootstrapping.
    pluto = inputs.darwin.lib.darwinSystem {
      inherit specialArgs;
      modules =
        [
          inputs.home-manager.darwinModules.home-manager
          {
            networking.hostName = "jupiter";
            nixpkgs.hostPlatform = "aarch64-darwin";
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

          gpg
          hammerspoon
          podman
        ]);
    };
  };
}
