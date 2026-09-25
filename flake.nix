{
  description = "Darwin and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    omniflake.url = "github:fzakaria/omniflake";
    omniflake.inputs.nixpkgs.follows = "nixpkgs";
    omniflake.inputs.flake-parts.follows = "flake-parts";

    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    yazi-flavors.url = "github:yazi-rs/flavors";
    yazi-flavors.flake = false;
    dcal.url = "github:avengemedia/dankcalendar";
    dcal.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs0: let
    flakes = inputs0.omniflake.flakes;
    compat = {
      wsl = flakes.nixos-wsl;
      darwin = flakes.nix-darwin;
      nur = flakes.nur;
      treefmt = flakes.treefmt-nix;
      git-hooks = flakes.git-hooks-nix;
      home-manager = flakes.home-manager;
      sops = flakes.sops-nix;
      disko = flakes.disko;
      nix-index-database = flakes.nix-index-database;
      helix = flakes.helix;
      zen-browser = flakes.zen-browser-flake;
      homebrew = flakes.nix-homebrew;
      omnibin = flakes.omnibin;
    };
    inputs = inputs0 // compat;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      imports = [(inputs.import-tree [./hosts ./modules])];
    };
}
