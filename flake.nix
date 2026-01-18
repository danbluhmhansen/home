{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    ez-configs.url = "github:ehllie/ez-configs";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";
    ez-configs.inputs.flake-parts.follows = "flake-parts";
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

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.flake-parts.follows = "flake-parts";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:gj1118/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    yazi-plugins.url = "github:yazi-rs/plugins";
    yazi-plugins.flake = false;
    yazi-ouch.url = "github:ndtoan96/ouch.yazi";
    yazi-ouch.flake = false;
    yazelix.url = "github:luccahuguet/yazelix";
    yazelix.flake = false;
    zjstatus.url = "github:dj95/zjstatus";
    zjstatus.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    sherlock.url = "github:skxxtz/sherlock";
    sherlock.inputs.nixpkgs.follows = "nixpkgs";
    sherlock.inputs.flake-parts.follows = "flake-parts";
    elephant.url = "github:abenz1267/elephant";
    elephant.inputs.nixpkgs.follows = "nixpkgs";
    walker.url = "github:abenz1267/walker";
    walker.inputs.nixpkgs.follows = "nixpkgs";
    walker.inputs.elephant.follows = "elephant";

    hs-spoons.url = "github:hammerspoon/spoons";
    hs-spoons.flake = false;
    hs-paperwm.url = "github:mogenson/paperwm.spoon";
    hs-paperwm.flake = false;
  };

  outputs = inputs @ {
    flake-parts,
    ez-configs,
    treefmt,
    git-hooks,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

      imports = [ez-configs.flakeModule treefmt.flakeModule git-hooks.flakeModule];

      ezConfigs = let
        user = "dan";
      in {
        root = ./.;
        globalArgs = {
          inherit inputs user;
          userName = "Dan Bluhm Hansen";
          email = "00.pavers_dither@icloud.com";
          timeZone = "Europe/Copenhagen";
        };

        darwin.configurationsDirectory = ./configurations/darwin;
        home.configurationsDirectory = ./configurations/home;
        nixos.configurationsDirectory = ./configurations/nixos;

        darwin.modulesDirectory = ./modules/darwin;
        home.modulesDirectory = ./modules/home;
        nixos.modulesDirectory = ./modules/nixos;

        darwin.hosts.jupiter.userHomeModules = [user];
        nixos.hosts.mercury.userHomeModules = [user];
        nixos.hosts.mars.userHomeModules = [user];
        nixos.hosts.saturn.userHomeModules = [user];
      };

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        treefmt.programs.alejandra.enable = true;
        pre-commit.settings.hooks.treefmt.enable = true;
        pre-commit.settings.hooks.treefmt.package = config.treefmt.build.wrapper;
        devShells.default = pkgs.mkShell {
          shellHook = config.pre-commit.installationScript;
          packages = with pkgs;
            [lua-language-server nil]
            ++ config.pre-commit.settings.enabledPackages
            ++ builtins.attrValues config.treefmt.build.programs;
        };
      };
    };
}
