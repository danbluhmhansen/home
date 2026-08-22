{inputs, ...}: {
  flake.modules.darwin.ghostty = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.ghostty];
    homebrew.casks = [
      {
        name = "ghostty@tip";
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
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {font-size = 15;};
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {package = null;};
  };
}
