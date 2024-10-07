{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.linux
    {
      home.file = {
        ".config/wezterm/wezterm.lua".text = "local wezterm = require 'wezterm'\n" + builtins.readFile ../../modules/home/wezterm/wezterm.lua;
      };
    }
    ../../modules/home/starship.nix
  ];
  home.username = "dan";
  home.homeDirectory = "/home/dan";
}
