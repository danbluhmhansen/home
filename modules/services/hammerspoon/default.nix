{inputs, ...}: {
  flake.modules.darwin.hammerspoon = {
    homebrew.casks = [
      {
        name = "hammerspoon";
        args.appdir = "~/Applications";
      }
    ];
  };
  flake.modules.homeManager.hammerspoon = {
    home.file = {
      ".hammerspoon/init.lua".source = ./init.lua;
      ".hammerspoon/Spoons/ReloadConfiguration.spoon/init.lua".source = "${inputs.hs-spoons}/Source/ReloadConfiguration.spoon/init.lua";
      ".hammerspoon/Spoons/PaperWM.spoon".source = inputs.hs-paperwm;
      ".hammerspoon/Spoons/PaperWM.spoon".recursive = true;
    };
  };
}
