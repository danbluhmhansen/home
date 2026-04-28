{
  flake.modules.nixos.niri = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [libnotify wayland-utils wl-clipboard xwayland-satellite];
    programs.niri.enable = true;
    programs.uwsm.enable = true;
    programs.uwsm.waylandCompositors.niri = {
      prettyName = "Niri";
      comment = "A scrollable-tiling Wayland compositor.";
      binPath = "/run/current-system/sw/bin/niri-session";
    };
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
