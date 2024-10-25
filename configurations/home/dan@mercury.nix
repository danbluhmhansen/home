{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.linux
    (
      {pkgs, ...}: {
        home.file = {
          ".config/wezterm/wezterm.lua".text = "local wezterm = require 'wezterm'\n" + builtins.readFile ../../modules/home/wezterm/wezterm.lua;
        };

        services.gpg-agent.enable = true;
        services.gpg-agent.enableSshSupport = true;
        services.gpg-agent.defaultCacheTtl = 60;
        services.gpg-agent.maxCacheTtl = 120;
        services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
      }
    )
    ../../modules/home/starship.nix
  ];
  home.username = "dan";
  home.homeDirectory = "/home/dan";
}
