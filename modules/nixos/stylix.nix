{
  pkgs,
  user,
  ...
}: let
  wallpaperDark = pkgs.fetchurl {
    name = "wallpaper.png";
    url = "https://initiate.alphacoders.com/download/images7/1397453/png";
    hash = "sha256-o+LGCMXiE+TiRiwwPCCHuZCEIYBncfhBElWidrGYU54=";
  };
  wallpaperLight = pkgs.fetchurl {
    name = "wallpaper.png";
    url = "https://initiate.alphacoders.com/download/images8/1397851/png";
    hash = "sha256-d2GQBw/V//5C6g6Vi/VMn6Lw/eekSffdXQZAaVok6O0=";
  };
in {
  security.doas.extraRules = [
    {
      users = [user];
      keepEnv = true;
      persist = true;
    }
    {
      groups = ["wheel"];
      cmd = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
      args = ["switch"];
      runAs = "root";
      noPass = true;
    }
    {
      groups = ["wheel"];
      cmd = "/nix/var/nix/profiles/system/specialisation/light/bin/switch-to-configuration";
      args = ["switch"];
      runAs = "root";
      noPass = true;
    }
  ];

  stylix = {
    base16Scheme = pkgs.lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = pkgs.lib.mkDefault "dark";
    cursor.package = pkgs.lib.mkDefault pkgs.catppuccin-cursors.mochaDark;
    cursor.name = pkgs.lib.mkDefault "catppuccin-mocha-dark-cursors";
    cursor.size = 24;
    fonts = {
      monospace.package = pkgs.maple-mono.NF;
      monospace.name = "Maple Mono NF";
    };
    image = pkgs.lib.mkDefault wallpaperDark;
  };

  specialisation.light.configuration = {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
      polarity = "light";
      cursor.package = pkgs.catppuccin-cursors.latteLight;
      cursor.name = "catppuccin-latte-light-cursors";
      image = wallpaperLight;
    };

    home-manager.sharedModules = [
      {
        programs.helix.settings.theme = "catppuccin_latte";

        programs.sherlock.settings.style = ''
          :root {
              /* backgrounds */
              --background: 220, 21%, 89%; /* Crust */
              --background-soft: 220, 23%, 95%; /* Base */
              --border:  220, 91%, 54%; /* Blue */
              --border-soft:  231, 97%, 72%; /* Lavender */
              --text:  234, 16%, 35%; /* Text */
              --text-active: 233, 10%, 47%; /* Subtext0 */

              --tag-background: 220, 23%, 95%; /* Base */

              /* foreground */
              --foreground: 223, 16%, 83%; /* Surface0 */
              --foreground-soft: 240, 21%, 12%; /* Mantle */

              /* accent colors */
              --error: 355, 76%, 59%; /* Maroon */
              --success:  109, 58%, 40%; /* Green */
              --warning: 22, 99%, 52%; /* Peach */
          }
        '';
      }
    ];
  };

  home-manager.sharedModules = [
    {
      stylix = {
        iconTheme.enable = true;
        iconTheme.package = pkgs.kdePackages.breeze-icons;
        iconTheme.dark = "breeze-dark";
        iconTheme.light = "breeze";
        targets.firefox.profileNames = [user];
        targets.helix.enable = false;
      };

      home.packages = [
        (pkgs.writeShellScriptBin "toggle-theme" ''
          #!/bin/sh
          # get current active system configuration
          current_system=$(readlink /run/current-system)
          # get the system path for the 'light' specialisation
          light_specialisation=$(readlink /nix/var/nix/profiles/system/specialisation/light)
          # check if the current system configuration matches the 'light' specialisation
          if [ "$current_system" == "$light_specialisation" ]; then
             notify-send "Switching to Dark"
             doas /nix/var/nix/profiles/system/bin/switch-to-configuration switch
             swww img ${wallpaperDark}
             pkill -USR1 hx
          else
             notify-send "Switching to Light"
             doas /nix/var/nix/profiles/system/specialisation/light/bin/switch-to-configuration switch
             swww img ${wallpaperLight}
             pkill -USR1 hx
          fi
        '')
      ];
    }
  ];
}
