{inputs, ...}: {
  flake.modules.nixos.wsl = {
    imports = [inputs.wsl.nixosModules.default];
    wsl = {
      enable = true;
      defaultUser = "dan";
      usbip.enable = true;
      useWindowsDriver = true;
    };
  };
}
