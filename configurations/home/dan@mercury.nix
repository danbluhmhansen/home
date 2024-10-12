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

        # services.darkman.enable = true;
        # services.darkman.darkModeScripts = {
        #   helix = pkgs.writers.writePython3 "helix-dark" {} ''
        #     import os
        #     with open(os.environ['HOME'] + '/.config/helix/themes/theme.toml', 'w') as file:
        #       file.write('inherits = "catppuccin_mocha"')
        #     os.system('pkill -USR1 hx')
        #   '';
        # };
        # services.darkman.lightModeScripts = {
        #   helix = pkgs.writers.writePython3 "helix-light" {} ''
        #     import os
        #     with open(os.environ['HOME'] + '/.config/helix/themes/theme.toml', 'w') as file:
        #       file.write('inherits = "catppuccin_latte"')
        #     os.system('pkill -USR1 hx')
        #   '';
        # };
      }
    )
    ../../modules/home/starship.nix
  ];
  home.username = "dan";
  home.homeDirectory = "/home/dan";
}
