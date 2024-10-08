{lib, ...}: {
  programs.broot = {
    enable = true;
    settings = {
      icon_theme = "nerdfont";
      imports = lib.mkForce ["skins/native-16.hjson"];
      verbs = [
        {
          invocation = "edit";
          shortcut = "e";
          key = "ctrl-e";
          external = ''$SHELL -ci "__wezterm_set_user_var br {file}:{line}"'';
          leave_broot = false;
        }
        {
          invocation = "open_stay";
          shortcut = "os";
          key = "enter";
          apply_to = "text_file";
          execution = "$EDITOR {file}";
          leave_broot = false;
        }
        {
          invocation = "open_leave";
          shortcut = "ol";
          key = "alt-enter";
          apply_to = "text_file";
          execution = "$EDITOR {file}";
          leave_broot = true;
        }
      ];
    };
  };
}
