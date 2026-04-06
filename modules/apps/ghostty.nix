{
  flake.modules.darwin.ghostty.homebrew.casks = [
    {
      name = "ghostty";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.ghostty = {
    pkgs,
    lib,
    ...
  }: {
    programs.ghostty =
      {
        enable = true;
        settings =
          {
            theme = "light:Catppuccin Latte,dark:Catppuccin Mocha";
            window-padding-balance = true;
            keybind = ["global:cmd+alt+backquote=toggle_quick_terminal"];
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {font-size = 15;};
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {package = null;};
  };
}
