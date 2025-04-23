{lib, ...}: {
  programs.broot = {
    enable = false;
    settings = {
      icon_theme = "nerdfont";
      imports = lib.mkForce ["skins/native-16.hjson"];
      verbs = [
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
          key = "ctrl-e";
          apply_to = "text_file";
          execution = "$EDITOR {file}";
          leave_broot = true;
        }
      ];
    };
  };
}
