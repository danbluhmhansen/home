{inputs, ...}: {
  flake.modules.darwin.zed = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.zed];
    homebrew.casks = [
      {
        name = "zed";
        args.appdir = "~/Applications";
      }
    ];
  };

  flake.modules.homeManager.zed = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.file = {
      ".config/zed/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/apps/zed/settings.json";
    };
    programs.zed-editor = {enable = true;} // lib.optionalAttrs pkgs.stdenv.isDarwin {package = null;};
  };
}
