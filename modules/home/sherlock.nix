{
  inputs,
  pkgs,
  ...
}: {
  programs.sherlock.package = inputs.sherlock.packages.${pkgs.stdenv.hostPlatform.system}.default;
  programs.sherlock.settings = {
    default_apps.terminal = "wezterm";
    appearance.width = 900;
    appearance.height = 593;
    appearance.gsk_renderer = "cairo";
    behavior.global_prefix = "uwsm app --";
    status_bar.enable = false;
    units.currency = "dkk";
    binds.left = "control-h";
    binds.down = "control-j";
    binds.up = "control-k";
    binds.right = "control-l";
    binds.context = "control-i";
  };

  programs.sherlock.launchers = [
    {
      name = "Weather";
      type = "weather";
      args.location = "roskilde";
      args.update_interval = 60;
      priority = 1;
      home = "OnlyHome";
      async = true;
      shortcut = false;
      spawn_focus = false;
    }
    {
      name = "Clipboard";
      type = "clipboard-execution";
      priority = 1;
      home = "Home";
    }
    {
      name = "Calculator";
      type = "calculation";
      priority = 1;
    }
    {
      name = "App Launcher";
      alias = "app";
      type = "app_launcher";
      priority = 2;
      home = "Home";
    }
    {
      name = "Bookmarks";
      alias = "bm";
      type = "command";
      args = {
        commands = {
          Forgejo = {
            exec = "xdg-open https://forgejo.920301.xyz &";
            search_string = "git;forgejo;";
          };
          GitHub = {
            exec = "xdg-open https://github.com &";
            search_string = "git;github;";
          };
          Foundry = {
            exec = "xdg-open https://foundry.920301.xyz &";
            search_string = "foundry;vtt;";
          };
          Jellyfin = {
            exec = "xdg-open https://jf.920301.xyz &";
            search_string = "jellyfin;streaming;";
          };
          Ombi = {
            exec = "xdg-open https://ombi.920301.xyz &";
            search_string = "ombi;";
          };
          Radarr = {
            exec = "xdg-open https://radarr.920301.xyz &";
            search_string = "radarr;";
          };
          Sonarr = {
            exec = "xdg-open https://sonarr.920301.xyz &";
            search_string = "sonarr;";
          };
        };
      };
      priority = 3;
    }
    {
      name = "Categories";
      alias = "cat";
      type = "categories";
      args = {
        categories = {
          Bookmarks = {
            icon = "sherlock-bookmark";
            icon_class = "reactive";
            exec = "bm";
            search_string = "bookmarks";
          };
          "Power Menu" = {
            icon = "battery-full-symbolic";
            icon_class = "reactive";
            exec = "pm";
            search_string = "powermenu;";
          };
        };
      };
      priority = 3;
      home = "Home";
    }
    {
      name = "Power Management";
      alias = "pm";
      type = "command";
      args = {
        commands = {
          Shutdown = {
            icon = "system-shutdown";
            exec = "systemctl poweroff";
            search_string = "Poweroff;Shutdown";
          };
          Sleep = {
            icon = "system-suspend";
            exec = "systemctl suspend";
            search_string = "Sleep;";
          };
          Lock = {
            icon = "system-lock-screen";
            exec = "swaylock";
            search_string = "Lock Screen;";
          };
          Reboot = {
            icon = "system-reboot";
            exec = "systemctl reboot";
            search_string = "reboot";
          };
          LogOut = {
            icon = "system-log-out";
            exec = "uwsm stop";
            search_string = "logout;signout";
          };
        };
      };
      priority = 4;
    }
    {
      name = "Emoji Picker";
      type = "emoji_picker";
      priority = 4;
    }
    {
      name = "Web Search";
      display_name = "DuckDuckGo Search";
      tag_start = "{keyword}";
      alias = "ddg";
      type = "web_launcher";
      args = {
        search_engine = "duckduckgo";
        icon = "duckduckgo";
      };
      priority = 100;
    }
  ];

  programs.sherlock.style = pkgs.lib.mkDefault ''
    :root {
      /* backgrounds */
      --background: hsl(240, 23%, 9%); /* Crust */
      --background-soft: hsl(240, 21%, 15%); /* Base */
      --border: hsl(217, 92%, 76%); /* Blue */
      --border-soft: hsl(232, 97%, 85%); /* Lavender */
      --text: hsl(226, 64%, 88%); /* Text */
      --text-active: hsl(228, 24%, 72%); /* Subtext0 */

      --tag-background: hsl(240, 21%, 15%); /* Base */

      /* foreground */
      --foreground: hsl(237, 16%, 23%); /* Surface0 */
      --foreground-soft: hsl(240, 21%, 12%); /* Mantle */

      /* accent colors */
      --error: hsl(350, 65%, 77%); /* Maroon */
      --success: hsl(115, 54%, 76%); /* Green */
      --warning: hsl(23, 92%, 75%); /* Peach */
    }
  '';

  programs.sherlock.ignore = ''
    qt*
  '';
}
