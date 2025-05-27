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

    # Software inputs
    nix-std.url = "github:chessai/nix-std";
    wezterm.url = "github:wezterm/wezterm?dir=nix";
    helix.url = "github:danbluhmhansen/helix/patchy";
    patchy.url = "github:nik-rev/patchy"; 
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake {
      inherit inputs;
      root = ./.;
    };
}
