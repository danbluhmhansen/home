{
  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    spacing = 4;
    modules-left = ["group/group-power" "custom/updates" "tray"];
    modules-center = [];
    modules-right = ["idle_inhibitor" "pulseaudio/slider" "pulseaudio" "clock"];
    keyboard-state = {
      numlock = true;
      capslock = true;
      format = "{name} {icon}";
      format-icons = {
        "locked" = "";
        "unlocked" = "";
      };
    };
    "sway/mode".format = "<span style=\"italic\">{}</span>";
    "sway/scratchpad" = {
      format = "{icon} {count}";
      show-empty = false;
      format-icons = ["" ""];
      tooltip = true;
      tooltip-format = "{app}: {title}";
    };
    mpd = {
      format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
      format-disconnected = "Disconnected ";
      format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
      unknown-tag = "N/A";
      interval = 5;
      consume-icons.on = " ";
      random-icons = {
        off = "<span color=\"#f53c3c\"></span> ";
        on = " ";
      };
      repeat-icons.on = " ";
      single-icons.on = "1 ";
      state-icons = {
        paused = "";
        playing = "";
      };
      tooltip-format = "MPD (connected)";
      tooltip-format-disconnected = "MPD (disconnected)";
    };
    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    tray = {
      icon-size = 16;
      spacing = 10;
    };
    clock = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%Y-%m-%d}";
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
    };
    memory.format = "{}% ";
    temperature = {
      critical-threshold = 80;
      format = "{temperatureC}°C {icon}";
      format-icons = ["" "" ""];
    };
    backlight = {
      format = "{percent}% {icon}";
      format-icons = ["" "" "" "" "" "" "" "" ""];
    };
    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-full = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-icons = ["" "" "" "" ""];
    };
    "battery#bat2".bat = "BAT2";
    power-profiles-daemon = {
      format = "{icon}";
      tooltip-format = "Power profile: {profile}\nDriver: {driver}";
      tooltip = true;
      format-icons = {
        default = "";
        performance = "";
        balanced = "";
        power-saver = "";
      };
    };
    network = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ipaddr}/{cidr} ";
      tooltip-format = "{ifname} via {gwaddr} ";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    pulseaudio = {
      scroll-step = 1;
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = " {icon} {format_source}";
      format-muted = " {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = ["" "" ""];
      };
      on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      on-click-right = "pavucontrol";
    };
    "pulseaudio/slider" = {
      min = 0;
      max = 100;
      orientation = "inherit";
    };
    "group/group-power" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 500;
        children-class = "not-power";
        transition-left-to-right = false;
      };
      modules = ["custom/power" "custom/quit" "custom/lock" "custom/reboot"];
    };
    "custom/quit" = {
      format = "󰗼";
      tooltip = false;
      on-click = "niri msg action quit";
    };
    "custom/lock" = {
      format = "󰍁";
      tooltip = false;
      on-click = "swaylock";
    };
    "custom/reboot" = {
      format = "󰜉";
      tooltip = false;
      on-click = "reboot";
    };
    "custom/power" = {
      format = "";
      tooltip = false;
      on-click = "shutdown now";
    };
    "custom/updates" = {
      format = "{} {icon}";
      return-type = "json";
      format-icons = {
        has-updates = "󱍷";
        updated = "󰂪";
      };
      exec-if = "which waybar-module-pacman-updates";
      exec = "waybar-module-pacman-updates --interval-seconds 5 --network-interval-seconds 300";
    };
  };

  # programs.waybar.style = ''
  #   /*
  #   *
  #   * Catppuccin Mocha palette
  #   * Maintainer: rubyowo
  #   *
  #   */

  #   @define-color base   #1e1e2e;
  #   @define-color mantle #181825;
  #   @define-color crust  #11111b;

  #   @define-color text     #cdd6f4;
  #   @define-color subtext0 #a6adc8;
  #   @define-color subtext1 #bac2de;

  #   @define-color surface0 #313244;
  #   @define-color surface1 #45475a;
  #   @define-color surface2 #585b70;

  #   @define-color overlay0 #6c7086;
  #   @define-color overlay1 #7f849c;
  #   @define-color overlay2 #9399b2;

  #   @define-color blue      #89b4fa;
  #   @define-color lavender  #b4befe;
  #   @define-color sapphire  #74c7ec;
  #   @define-color sky       #89dceb;
  #   @define-color teal      #94e2d5;
  #   @define-color green     #a6e3a1;
  #   @define-color yellow    #f9e2af;
  #   @define-color peach     #fab387;
  #   @define-color maroon    #eba0ac;
  #   @define-color red       #f38ba8;
  #   @define-color mauve     #cba6f7;
  #   @define-color pink      #f5c2e7;
  #   @define-color flamingo  #f2cdcd;
  #   @define-color rosewater #f5e0dc;

  #   * {
  #     /* reference the color by using @color-name */
  #     color: @text;
  #     font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
  #   }

  #   window#waybar {
  #     /* you can also GTK3 CSS functions! */
  #     background-color: shade(@base, 0.9);
  #     border: 2px solid alpha(@crust, 0.3);
  #     transition-property: background-color;
  #     transition-duration: .5s;
  #   }


  #   window#waybar.hidden {
  #     opacity: 0.2;
  #   }

  #   /*
  #   window#waybar.empty {
  #       background-color: transparent;
  #   }
  #   window#waybar.solo {
  #       background-color: #FFFFFF;
  #   }
  #   */

  #   window#waybar.termite {
  #     background-color: #3F3F3F;
  #   }

  #   window#waybar.chromium {
  #     background-color: #000000;
  #     border: none;
  #   }

  #   button {
  #     /* Use box-shadow instead of border so the text isn't offset */
  #     box-shadow: inset 0 -3px transparent;
  #     /* Avoid rounded borders under each button name */
  #     border: none;
  #     border-radius: 0;
  #   }

  #   /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
  #   button:hover {
  #     background: inherit;
  #     box-shadow: inset 0 -3px #ffffff;
  #   }

  #   #workspaces button {
  #     padding: 0 5px;
  #     background-color: transparent;
  #     color: #ffffff;
  #   }

  #   #workspaces button:hover {
  #     background: rgba(0, 0, 0, 0.2);
  #   }

  #   #workspaces button.focused {
  #     background-color: #64727D;
  #     box-shadow: inset 0 -3px #ffffff;
  #   }

  #   #workspaces button.urgent {
  #     background-color: #eb4d4b;
  #   }

  #   #mode {
  #     background-color: #64727D;
  #     box-shadow: inset 0 -3px #ffffff;
  #   }

  #   #clock,
  #   #battery,
  #   #cpu,
  #   #memory,
  #   #disk,
  #   #temperature,
  #   #backlight,
  #   #network,
  #   #pulseaudio,
  #   #wireplumber,
  #   #custom-media,
  #   #tray,
  #   #mode,
  #   #idle_inhibitor,
  #   #scratchpad,
  #   #power-profiles-daemon,
  #   #mpd {
  #     padding: 0 10px;
  #     color: #ffffff;
  #   }

  #   #window,
  #   #workspaces {
  #     margin: 0 4px;
  #   }

  #   /* If workspaces is the leftmost module, omit left margin */
  #   .modules-left>widget:first-child>#workspaces {
  #     margin-left: 0;
  #   }

  #   /* If workspaces is the rightmost module, omit right margin */
  #   .modules-right>widget:last-child>#workspaces {
  #     margin-right: 0;
  #   }

  #   #clock {}

  #   #battery {
  #     background-color: #ffffff;
  #     color: #000000;
  #   }

  #   #battery.charging,
  #   #battery.plugged {
  #     color: #ffffff;
  #     background-color: #26A65B;
  #   }

  #   @keyframes blink {
  #     to {
  #       background-color: #ffffff;
  #       color: #000000;
  #     }
  #   }

  #   /* Using steps() instead of linear as a timing function to limit cpu usage */
  #   #battery.critical:not(.charging) {
  #     background-color: #f53c3c;
  #     color: #ffffff;
  #     animation-name: blink;
  #     animation-duration: 0.5s;
  #     animation-timing-function: steps(12);
  #     animation-iteration-count: infinite;
  #     animation-direction: alternate;
  #   }

  #   #power-profiles-daemon {
  #     padding-right: 15px;
  #   }

  #   #power-profiles-daemon.performance {
  #     background-color: #f53c3c;
  #     color: #ffffff;
  #   }

  #   #power-profiles-daemon.balanced {
  #     background-color: #2980b9;
  #     color: #ffffff;
  #   }

  #   #power-profiles-daemon.power-saver {
  #     background-color: #2ecc71;
  #     color: #000000;
  #   }

  #   label:focus {
  #     background-color: #000000;
  #   }

  #   #cpu {
  #     background-color: #2ecc71;
  #     color: #000000;
  #   }

  #   #memory {
  #     background-color: #9b59b6;
  #   }

  #   #disk {
  #     background-color: #964B00;
  #   }

  #   #backlight {
  #     background-color: #90b1b1;
  #   }

  #   #network {
  #     background-color: #2980b9;
  #   }

  #   #network.disconnected {
  #     background-color: #f53c3c;
  #   }

  #   #pulseaudio {}

  #   #pulseaudio.muted {}

  #   #wireplumber {
  #     background-color: #fff0f5;
  #     color: #000000;
  #   }

  #   #wireplumber.muted {
  #     background-color: #f53c3c;
  #   }

  #   #custom-media {
  #     background-color: #66cc99;
  #     color: #2a5c45;
  #     min-width: 100px;
  #   }

  #   #custom-media.custom-spotify {
  #     background-color: #66cc99;
  #   }

  #   #custom-media.custom-vlc {
  #     background-color: #ffa000;
  #   }

  #   #temperature {
  #     background-color: #f0932b;
  #   }

  #   #temperature.critical {
  #     background-color: #eb4d4b;
  #   }

  #   #tray {}

  #   #tray>.passive {
  #     -gtk-icon-effect: dim;
  #   }

  #   #tray>.needs-attention {
  #     -gtk-icon-effect: highlight;
  #     background-color: #eb4d4b;
  #   }

  #   #idle_inhibitor {}

  #   #idle_inhibitor.activated {
  #     background-color: @rosewater;
  #     color: @base;
  #   }

  #   #mpd {
  #     background-color: #66cc99;
  #     color: #2a5c45;
  #   }

  #   #mpd.disconnected {
  #     background-color: #f53c3c;
  #   }

  #   #mpd.stopped {
  #     background-color: #90b1b1;
  #   }

  #   #mpd.paused {
  #     background-color: #51a37a;
  #   }

  #   #language {
  #     background: #00b093;
  #     color: #740864;
  #     padding: 0 5px;
  #     margin: 0 5px;
  #     min-width: 16px;
  #   }

  #   #keyboard-state {
  #     background: #97e1ad;
  #     color: #000000;
  #     padding: 0 0px;
  #     margin: 0 5px;
  #     min-width: 16px;
  #   }

  #   #keyboard-state>label {
  #     padding: 0 5px;
  #   }

  #   #keyboard-state>label.locked {
  #     background: rgba(0, 0, 0, 0.2);
  #   }

  #   #scratchpad {
  #     background: rgba(0, 0, 0, 0.2);
  #   }

  #   #scratchpad.empty {
  #     background-color: transparent;
  #   }

  #   #privacy {
  #     padding: 0;
  #   }

  #   #privacy-item {
  #     padding: 0 5px;
  #     color: white;
  #   }

  #   #privacy-item.screenshare {
  #     background-color: #cf5700;
  #   }

  #   #privacy-item.audio-in {
  #     background-color: #1ca000;
  #   }

  #   #privacy-item.audio-out {
  #     background-color: #0069d4;
  #   }

  #   #pulseaudio-slider trough,
  #   #backlight-slider trough {
  #     min-height: 10px;
  #     min-width: 80px;
  #   }

  #   #group-power {
  #     margin-left: 8px;
  #     font-size: 24px;
  #   }

  #   .not-power {
  #     padding-left: 8px;
  #   }
  # '';
}
