{inputs, ...}: {
  flake.modules.homeManager.dcal = {
    imports = [inputs.dcal.homeModules.default];
    programs.dank-calendar = {
      enable = true;
      systemd.enable = true;
    };
  };
}
