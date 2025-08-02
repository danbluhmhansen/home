{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.sherlock.homeManagerModules.default];

  programs.sherlock.settings.config = {
    default_apps.terminal = "wezterm";
    appearance.width = 900;
    appearance.height = 593;
    appearance.gsk_renderer = "cairo";
    appearance.status_bar = false;
    behavior.global_prefix = "uwsm app -- ";
    binds.prev = "control-p";
    binds.next = "control-n";
    binds.context = "control-l";
  };

  programs.sherlock.settings.launchers = [
    {
      name = "Weather";
      type = "weather";
      args.location = "roskilde";
      args.update_interval = 60;
      priority = 1;
      home = true;
      only_home = true;
      async = true;
      shortcut = false;
      spawn_focus = false;
    }
    {
      name = "Clipboard";
      type = "clipboard-execution";
      priority = 1;
      home = true;
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
      home = true;
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
      home = true;
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
      home = false;
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

  programs.sherlock.settings.style = lib.mkDefault ''
    :root {
        /* backgrounds */
        --background: 240, 23%, 9%; /* Crust */
        --background-soft: 240, 21%, 15%; /* Base */
        --border:  217, 92%, 76%; /* Blue */
        --border-soft:  232, 97%, 85%; /* Lavender */
        --text:  226, 64%, 88%; /* Text */
        --text-active: 228, 24%, 72%; /* Subtext0 */

        --tag-background: 240, 21%, 15%; /* Base */

        /* foreground */
        --foreground: 237, 16%, 23%; /* Surface0 */
        --foreground-soft: 240, 21%, 12%; /* Mantle */

        /* accent colors */
        --error: 350, 65%, 77%; /* Maroon */
        --success:  115, 54%, 76%; /* Green */
        --warning: 23, 92%, 75%; /* Peach */
    }
  '';

  programs.sherlock.settings.ignore = ''
    qt*
  '';
}
