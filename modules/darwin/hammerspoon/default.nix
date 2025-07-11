{inputs, ...}: {
  home.file = {
    ".hammerspoon/init.lua".source = ./init.lua;
    ".hammerspoon/Spoons/ReloadConfiguration.spoon/init.lua".source = "${inputs.hs-spoons}/Source/ReloadConfiguration.spoon/init.lua";
    ".hammerspoon/Spoons/PaperWM.spoon/init.lua".source = "${inputs.hs-paperwm}/init.lua";
    ".hammerspoon/Spoons/PaperWM.spoon/mission_control.lua".source = "${inputs.hs-paperwm}/mission_control.lua";
    ".hammerspoon/Spoons/PaperWM.spoon/swipe.lua".source = "${inputs.hs-paperwm}/swipe.lua";
  };
}
