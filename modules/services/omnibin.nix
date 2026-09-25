{inputs, ...}: {
  flake.modules.nixos.omnibin = {
    imports = [inputs.omnibin.nixosModules.default];
    services.omnibin = {
      enable = true;
      mountStore = false;
    };
  };
}
