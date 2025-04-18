{pkgs, ...}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b12a9ab085a8c2fe2b921e1547ee667b714185f9";
    hash = "sha256-LWN0riaUazQl3llTNNUMktG+7GLAHaG/IxNj1gFhDRE=";
  };
  yazi-ouch = pkgs.fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "2496cd9ac2d1fb52597b22ae84f3af06c826a86d";
    hash = "sha256-OsNfR7rtnq+ceBTiFjbz+NFMSV/6cQ1THxEFzI4oPJk=";
  };
in {
  programs.yazi.enable = true;
  programs.yazi.plugins = {
    diff = "${yazi-plugins}/diff.yazi";
    git = "${yazi-plugins}/git.yazi";
    jump-to-char = "${yazi-plugins}/jump-to-char.yazi";
    mount = "${yazi-plugins}/mount.yazi";
    ouch = "${yazi-ouch}";
    smart-enter = "${yazi-plugins}/smart-enter.yazi";
    smart-filter = "${yazi-plugins}/smart-filter.yazi";
    vcs-files = "${yazi-plugins}/vcs-files.yazi";
  };
  programs.yazi.initLua = ''
    require("git"):setup()
  '';
  programs.yazi.settings = {
    plugin.prepend_fetchers = [
      {
        id = "git";
        name = "*";
        run = "git";
      }
      {
        id = "git";
        name = "*/";
        run = "git";
      }
    ];
    plugin.prepend_previewers = [
      {
        mime = "application/*zip";
        run = "ouch";
      }
      {
        mime = "application/x-tar";
        run = "ouch";
      }
      {
        mime = "application/x-bzip2";
        run = "ouch";
      }
      {
        mime = "application/x-7z-compressed";
        run = "ouch";
      }
      {
        mime = "application/x-rar";
        run = "ouch";
      }
      {
        mime = "application/x-xz";
        run = "ouch";
      }
      {
        mime = "application/xz";
        run = "ouch";
      }
    ];
  };
  programs.yazi.keymap = {
    manager.prepend_keymap = [
      {
        on = "<C-d>";
        run = "plugin diff";
        desc = "Diff the selected with the hovered file";
      }
      {
        on = "f";
        run = "plugin jump-to-char";
        desc = "Jump to char";
      }
      {
        on = "M";
        run = "plugin mount";
      }
      {
        on = "C";
        run = "plugin ouch";
        desc = "Compress with ouch";
      }
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
      {
        on = "F";
        run = "plugin smart-filter";
        desc = "Smart filter";
      }
      {
        on = ["g" "c"];
        run = "plugin vcs-files";
        desc = "Show Git file changes";
      }
    ];
  };
  programs.yazi.theme = {
    mode = {
      normal_main = {
        fg = "black";
        bg = "blue";
        bold = true;
      };
      normal_alt = {
        fg = "blue";
        bg = "darkgray";
      };
      select_main = {
        fg = "black";
        bg = "red";
        bold = true;
      };
      select_alt = {
        fg = "red";
        bg = "darkgray";
      };
      unset_main = {
        fg = "black";
        bg = "red";
        bold = true;
      };
      unset_alt = {
        fg = "red";
        bg = "darkgray";
      };
    };
  };
}
