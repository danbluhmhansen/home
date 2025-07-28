{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  wayland.windowManager.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  wayland.windowManager.hyprland.settings = {
    general.layout = "scrolling";
    general.gaps_out = 5;

    input.kb_layout = "us,dk";
    input.kb_options = "grp:alt_space_toggle";

    animation = ["workspaces, 1, 5, default, slidevert"];

    binds.drag_threshold = 10;

    "$mod" = "SUPER";

    bindr = ["$mod, SUPER_L, exec, uwsm app -- sherlock"];

    bind = [
      "$mod CONTROL, E, exec, uwsm stop"
      "$mod, W, killactive"
      "$mod, F, fullscreen,"
      "$mod, T, togglefloating,"
      "$mod, Q, exec, uwsm app -- wezterm"
      "$mod, N, exec, uwsm app -- swaync-client -t"
      "$mod, E, exec, uwsm app -- swaylock"
      "$mod, S, exec, toggle-theme"

      "$mod, R, layoutmsg, colresize +conf"
      "$mod CONTROL, R, layoutmsg, colresize -conf"

      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      "$mod CONTROL, H, layoutmsg, movewindowto l"
      "$mod CONTROL, J, layoutmsg, movewindowto d"
      "$mod CONTROL, K, layoutmsg, movewindowto u"
      "$mod CONTROL, L, layoutmsg, movewindowto r"

      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      "$mod CONTROL, 1, movetoworkspace, 1"
      "$mod CONTROL, 2, movetoworkspace, 2"
      "$mod CONTROL, 3, movetoworkspace, 3"
      "$mod CONTROL, 4, movetoworkspace, 4"
      "$mod CONTROL, 5, movetoworkspace, 5"
      "$mod CONTROL, 6, movetoworkspace, 6"
      "$mod CONTROL, 7, movetoworkspace, 7"
      "$mod CONTROL, 8, movetoworkspace, 8"
      "$mod CONTROL, 9, movetoworkspace, 9"
      "$mod CONTROL, 0, movetoworkspace, 10"
    ];

    bindm = ["$mod, mouse:272, movewindow"];
    bindc = ["$mod, mouse:272, togglefloating"];

    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ];

    bindl = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
    ];

    plugin.hyprscrolling = {
      column_width = toString (1. / 3.);
      explicit_column_widths = pkgs.lib.concatStringsSep ", " (map (x: toString x) [(5. / 16.) (1. / 3.) (3. / 8.) (1. / 2.) (2. / 3.)]);
    };
  };

  wayland.windowManager.hyprland.extraConfig = ''
    monitorv2 {
      output=DP-3
      mode=3440x1440@240
      position=0x0
      scale=1
      bitdepth=10
      cm=hdr
      supports_hdr=1
      sdr_max_luminance=250
      sdr_min_luminance=0.005
    }
  '';

  wayland.windowManager.hyprland.plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [hyprscrolling];
}
