{inputs, ...}: {
  flake.modules.nixos.wsl = {
    imports = [inputs.wsl.nixosModules.default];
    wsl.enable = true;
    wsl.defaultUser = "dan";
    wsl.usbip.enable = true;
  };
}
