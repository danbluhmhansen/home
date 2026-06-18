{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: {
    home-manager.sharedModules = [inputs.self.modules.homeManager.niri];
    environment.systemPackages = with pkgs; [libnotify wayland-utils wl-clipboard xwayland-satellite];
    programs.niri.enable = true;
  };

  flake.modules.homeManager.niri = {config, ...}: {
    home.file = {
      ".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/desktop/niri/config.kdl";
      ".config/niri/dms" = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/desktop/niri/dms";
        recursive = true;
      };
    };
  };
}
