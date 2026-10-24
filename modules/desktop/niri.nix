{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: {
    home-manager.sharedModules = [inputs.self.modules.homeManager.niri];
    environment.systemPackages = with pkgs; [
      libnotify
      wayland-utils
      wl-clipboard
      accountsservice
      adw-gtk3
      catppuccin-cursors.mochaDark
      catppuccin-cursors.latteLight
      kdePackages.breeze-icons
    ];
    programs.niri.enable = true;
    hardware.i2c.enable = true;
    xdg.icons.fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
  };

  flake.modules.homeManager.niri = {
    wayland.windowManager.niri = {
      enable = true;
      enableDefaultConfig = true;

      settings = {
        input = {
          keyboard.xkb = {
            layout = "us,dk";
            options = "grp:alt_space_toggle";
          };
        };

        layout = {
          center-focused-column = "on-overflow";
          preset-column-widths._children = [
            {proportion = 0.312500;}
            {proportion = 0.333333;}
            {proportion = 0.375000;}
            {proportion = 0.500000;}
            {proportion = 0.666667;}
          ];
          default-column-width.proportion = 0.333333;
        };

        hotkey-overlay = {
          skip-at-startup = {};
          hide-not-bound = {};
        };

        prefer-no-csd = {};

        output = {
          _args = ["DP-3"];
          mode = "3440x1440@239.989";
          variable-refresh-rate._props.on-demand = true;
          layout.always-center-single-column = {};
        };

        binds = {
          "Ctrl+XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "3%-"];
          };

          "Ctrl+XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "3%+"];
          };

          "Mod+E" = {
            _props.hotkey-overlay-title = "Lock Screen";
            spawn = ["loginctl" "lock-session"];
          };

          "Mod+N" = {
            _props.hotkey-overlay-title = "Dismiss Notification";
            spawn = ["makoctl" "dismiss"];
          };

          "Mod+Space" = {
            _props.hotkey-overlay-title = "Application Launcher";
            spawn = ["walker"];
          };

          "Mod+V" = {
            _props.hotkey-overlay-title = "Clipboard";
            spawn = ["walker" "-m" "clipboard"];
          };

          "XF86AudioLowerVolume" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
          };

          "XF86AudioPause" = {
            _props.allow-when-locked = true;
            spawn = ["playerctl" "play-pause"];
          };

          "XF86AudioRaiseVolume" = {
            _props.allow-when-locked = true;
            spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
          };

          "XF86MonBrightnessDown" = {
            _props.allow-when-locked = true;
            spawn = ["brightnessctl" "set" "5%-"];
          };

          "XF86MonBrightnessUp" = {
            _props.allow-when-locked = true;
            spawn = ["brightnessctl" "set" "5%+"];
          };

          "Mod+Ctrl+Down" = {move-column-to-workspace-down = {};};

          "Mod+Ctrl+Up" = {move-column-to-workspace-up = {};};

          "Mod+J" = {focus-window-or-workspace-down = {};};

          "Mod+K" = {focus-window-or-workspace-up = {};};

          "Mod+Shift+1" = {move-column-to-workspace = 1;};

          "Mod+Shift+2" = {move-column-to-workspace = 2;};

          "Mod+Shift+3" = {move-column-to-workspace = 3;};

          "Mod+Shift+4" = {move-column-to-workspace = 4;};

          "Mod+Shift+5" = {move-column-to-workspace = 5;};

          "Mod+Shift+6" = {move-column-to-workspace = 6;};

          "Mod+Shift+7" = {move-column-to-workspace = 7;};

          "Mod+Shift+8" = {move-column-to-workspace = 8;};

          "Mod+Shift+9" = {move-column-to-workspace = 9;};

          "Mod+Shift+Down" = {move-window-down-or-to-workspace-down = {};};

          "Mod+Shift+J" = {move-window-down-or-to-workspace-down = {};};

          "Mod+Shift+K" = {move-window-up-or-to-workspace-up = {};};

          "Mod+Shift+Up" = {move-window-up-or-to-workspace-up = {};};

          "Alt+XF86Launch1" = {screenshot-window = {};};

          "Mod+Ctrl+H" = {focus-monitor-left = {};};

          "Mod+Ctrl+J" = {focus-monitor-down = {};};

          "Mod+Ctrl+K" = {focus-monitor-up = {};};

          "Mod+Ctrl+L" = {focus-monitor-right = {};};

          "Mod+Ctrl+Left" = {focus-monitor-left = {};};

          "Mod+Ctrl+Right" = {focus-monitor-right = {};};

          "Mod+Shift+H" = {move-column-left = {};};

          "Mod+Shift+L" = {move-column-right = {};};

          "Mod+Shift+Left" = {move-column-left = {};};

          "Mod+Shift+Right" = {move-column-right = {};};

          "Mod+Shift+T" = {toggle-window-floating = {};};

          "Mod+T" = {toggle-column-tabbed-display = {};};

          "Mod+W" = {
            _props.repeat = false;
            close-window = {};
          };

          "Ctrl+XF86Launch1" = {screenshot-screen = {};};

          "XF86Launch1" = {screenshot = {};};

          "Mod+Q" = {
            _props.hotkey-overlay-title = "Open Terminal";
            spawn = ["ghostty"];
          };

          "Mod+D" = {
            _props.repeat = false;
            toggle-overview = {};
          };

          "Mod+Tab" = {
            _props.repeat = false;
            toggle-overview = {};
          };
        };

        _children = [
          {
            window-rule = {
              match._props.app-id = ''^org\.gnome\.'';
              draw-border-with-background = false;
              geometry-corner-radius = 12;
              clip-to-geometry = true;
            };
          }
          {
            window-rule = {
              _children = [
                {match._props.app-id = ''^gnome-control-center$'';}
                {match._props.app-id = ''^pavucontrol$'';}
                {match._props.app-id = ''^nm-connection-editor$'';}
              ];
              default-column-width.proportion = 0.5;
              open-floating = false;
            };
          }
          {
            window-rule = {
              _children = [
                {match._props.app-id = ''^gnome-calculator$'';}
                {match._props.app-id = ''^galculator$'';}
                {match._props.app-id = ''^blueman-manager$'';}
                {match._props.app-id = ''^org\.gnome\.Nautilus$'';}
                {match._props.app-id = ''^xdg-desktop-portal$'';}
              ];
              open-floating = true;
            };
          }
          {
            window-rule = {
              match._props.app-id = ''^steam$'';
              match._props.title = ''^notificationtoasts_\d+_desktop$'';
              default-floating-position._props = {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              };
              open-focused = false;
            };
          }
          {
            window-rule = {
              _children = [
                {
                  match._props.app-id = "firefox$";
                  match._props.title = ''^Picture-in-Picture$'';
                }
                {match._props.app-id = "zoom";}
              ];
              open-floating = true;
            };
          }

          {
            window-rule = {
              match._props.app-id = ''^steam_app_\\d+$'';
              open-fullscreen = true;
            };
          }
          {
            window-rule = {
              match._props.app-id = ''^deadcells$'';
              open-fullscreen = true;
            };
          }
        ];
      };
    };
  };
}
