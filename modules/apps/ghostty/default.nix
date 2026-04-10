{
  flake.modules.darwin.ghostty.homebrew.casks = [
    {
      name = "ghostty";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.ghostty = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.file = {
      ".config/ghostty/config".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home/modules/apps/ghostty/config";
    };
    programs.ghostty = {enable = true;} // lib.optionalAttrs pkgs.stdenv.isDarwin {package = null;};
  };
}
