{
  flake.modules.homeManager.zellij = {
    programs.zellij = {
      enable = true;
      settings = {
        default_mode = "locked";
        default_layout = "compact";
        theme = "ansi";
        theme_dark = "catppuccin-macchiato";
        theme_light = "catppuccin-latte";
        show_startup_tips = false;

        plugins = {
          about._props.location = "zellij:about";
          "compact-bar"._props.location = "zellij:compact-bar";
          "compact-bar"._children = [{tooltip = "F1";}];
          configuration._props.location = "zellij:configuration";
          filepicker._props.location = "zellij:strider";
          filepicker._props.cwd = "/";
          "plugin-manager"._props.location = "zellij:plugin-manager";
          "session-manager"._props.location = "zellij:session-manager";
          "status-bar"._props.location = "zellij:status-bar";
          strider._props.location = "zellij:strider";
          "tab-bar"._props.location = "zellij:tab-bar";
          "welcome-screen"._props.location = "zellij:session-manager";
          "welcome-screen"._props.welcome_screen = true;
        };

        load_plugins._children = [{"zellij:link" = {};}];

        web_client._props.font = "monospace";
      };

      extraConfig = builtins.readFile ./config.kdl;
    };
  };
}
