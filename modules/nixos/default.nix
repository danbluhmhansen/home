# Configuration common to all Linux systems
{flake, ...}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      # users.users.${config.me.username}.isNormalUser = true;
      home-manager.users.${config.me.username} = {};
      home-manager.sharedModules = [
        self.homeModules.default
        self.homeModules.linux
      ];
    }
    self.nixosModules.common
  ];
}
