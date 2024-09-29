# My Ubuntu VM
{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.linux
  ];
  home.username = "dan";
  home.homeDirectory = "/home/dan";
  # home-manager.extraSpecialArgs = {
  #   helix-master = inputs.helix;
  # };
}
