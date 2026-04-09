{
  description = "Darwin and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wsl.url = "github:nix-community/nixos-wsl";
    wsl.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    rosetta-builder.inputs.nixpkgs.follows = "nixpkgs";

    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops.url = "github:mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    yazi-flavors.url = "github:yazi-rs/flavors";
    yazi-flavors.flake = false;

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    dms.url = "github:avengemedia/dankmaterialshell/stable";
    dms.inputs.nixpkgs.follows = "nixpkgs";

    hs-spoons.url = "github:hammerspoon/spoons";
    hs-spoons.flake = false;
    hs-paperwm.url = "github:mogenson/paperwm.spoon";
    hs-paperwm.flake = false;
  };

  outputs = inputs: let
    specialArgs = {inherit inputs;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      debug = true;
      imports = [(inputs.import-tree [./hosts ./modules])];
      _module.args.rootPath = ./.;
      # TODO: Having the darwin configurations imported using `import-tree` seems to cause infinite recursion. Check for
      # a fix and move to separate files again.
      flake.darwinConfigurations.jupiter = inputs.darwin.lib.darwinSystem {
        inherit specialArgs;
        modules =
          [
            inputs.home-manager.darwinModules.home-manager
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
      flake.darwinConfigurations.pluto = inputs.darwin.lib.darwinSystem {
        inherit specialArgs;
        modules =
          [
            inputs.home-manager.darwinModules.home-manager
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

            gpg
            hammerspoon
            podman
          ]);
      };
    });
}
