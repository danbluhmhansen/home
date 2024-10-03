# Configuration common to all macOS systems
{flake, ...}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      nixpkgs.overlays = [inputs.firefox-darwin.overlay];
      home-manager.users.${config.me.username} = {};
      home-manager.sharedModules = [
        ({pkgs, ...}: {
          home.file = {
            ".hammerspoon/init.lua".source = ./programs/hammerspoon/init.lua;
            ".hammerspoon/Spoons/ReloadConfiguration.spoon".source = pkgs.fetchzip {
              url = "https://github.com/Hammerspoon/Spoons/raw/c53546e00552451e077677a92eb1646c65acdca1/Spoons/ReloadConfiguration.spoon.zip";
              hash = "sha256-kNyFHP3i1O4VhZQL2Ief6002TrvXzT4doZ9w8X5z6C0=";
            };
            ".hammerspoon/Spoons/PaperWM.spoon/init.lua".source = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/mogenson/PaperWM.spoon/02a9ec65217167882b14c480cc1f7a0365f53f66/init.lua";
              hash = "sha256-setLXaKf43weN1Cj1jaeng30zxjeWQ/qz310+MbWB2A=";
            };
          };
        })
        self.homeModules.default
        self.homeModules.darwin
      ];
    }
    self.nixosModules.common
  ];
}
