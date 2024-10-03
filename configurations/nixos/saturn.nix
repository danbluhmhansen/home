{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [self.nixosModules.default];

  system.stateVersion = "24.05";
  networking.hostName = "saturn";
  nixpkgs.hostPlatform = "x86_64-linux";
}
