{pkgs, ...}: {
  home.file = {
    ".hammerspoon/init.lua".source = ./init.lua;
    ".hammerspoon/Spoons/ReloadConfiguration.spoon/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Hammerspoon/Spoons/640619cdffc7bb67b9273d059a32586d55be17f8/Source/ReloadConfiguration.spoon/init.lua";
      hash = "sha256-lNnrff43pjJ7pPPUTHlVTCywWx4eU1GVPSFr7NAUs7c=";
    };
    ".hammerspoon/Spoons/PaperWM.spoon/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/mogenson/PaperWM.spoon/d6366efed263793df5919b2f6d7185c9056995c6/init.lua";
      hash = "sha256-fYkY/Y7AB8BYrkexxsZuI22iAeMwNa14cxBg/ZIA2RY=";
    };
    ".hammerspoon/Spoons/PaperWM.spoon/mission_control.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/mogenson/PaperWM.spoon/d6366efed263793df5919b2f6d7185c9056995c6/mission_control.lua";
      hash = "sha256-xdvtPvM56jXsLZ+T6NONdhIKyFii6TZRemhPaMJWsvw=";
    };
  };
}
