{
  inputs = {
    # Principal inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Software inputs
    nix-std.url = "github:chessai/nix-std";
    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    helix.url = "github:nik-rev/helix/patchy";
    patchy.url = "github:nikitarevenco/patchy";
  };

  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake {
      inherit inputs;
      root = ./.;
    };
}
