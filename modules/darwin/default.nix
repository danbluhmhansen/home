# Configuration common to all macOS systems
{flake, ...}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [self.nixosModules.common];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  nixpkgs.overlays = [inputs.firefox-darwin.overlay];
  home-manager.users.${config.me.username} = {};
  home-manager.sharedModules = [
    self.homeModules.default
    self.homeModules.darwin
    ./hammerspoon
  ];
}
