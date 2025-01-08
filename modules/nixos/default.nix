# Configuration common to all Linux systems
{flake, ...}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [self.nixosModules.common];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  users.users.${flake.config.me.username} = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = ["wheel"];
  };
  home-manager.users.${config.me.username} = {};
  home-manager.sharedModules = [
    self.homeModules.default
    self.homeModules.linux
  ];
}
