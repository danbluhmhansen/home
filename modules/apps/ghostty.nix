{inputs, ...}: {
  flake.modules.darwin.ghostty = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.ghostty];
    homebrew.casks = [
      {
        name = "ghostty";
        args.appdir = "~/Applications";
      }
    ];
  };

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
            config-file = ["?local.ghostty"];
            keybind = ["global:cmd+alt+backquote=toggle_quick_terminal"];
            theme = "light:Catppuccin Latte,dark:Catppuccin Mocha";
            window-padding-balance = true;
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {font-size = 15;};
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {package = null;};
  };
}
