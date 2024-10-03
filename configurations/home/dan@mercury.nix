{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.linux
  ];
  home.username = "dan";
  home.homeDirectory = "/home/dan";
}
