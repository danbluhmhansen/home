{
  flake.modules.homeManager.waybar = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.targets = ["niri.service"];
      settings = {
        mainBar = {
          output = "DP-3";
          layer = "top";
          modules-left = ["niri/window" "privacy"];
          modules-center = ["niri/workspaces"];
          modules-right = [
            "mpd"
            "idle_inhibitor"
            "pulseaudio"
            "power-profiles-daemon"
            "temperature"
            "niri/language"
            "tray"
            "clock"
          ];
          temperature.hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp1_input";
        };
      };
    };
  };
}
