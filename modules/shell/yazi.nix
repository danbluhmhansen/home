{inputs, ...}: {
  flake.modules.homeManager.yazi = {
    programs.yazi = {
      enable = true;
      plugins = {
        diff = "${inputs.yazi-plugins}/diff.yazi";
        git = "${inputs.yazi-plugins}/git.yazi";
        jump-to-char = "${inputs.yazi-plugins}/jump-to-char.yazi";
        mount = "${inputs.yazi-plugins}/mount.yazi";
        ouch = "${inputs.yazi-ouch}";
        smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
        smart-filter = "${inputs.yazi-plugins}/smart-filter.yazi";
        toggle-pane = "${inputs.yazi-plugins}/toggle-pane.yazi";
        vcs-files = "${inputs.yazi-plugins}/vcs-files.yazi";
      };

      initLua = ''
        require("git"):setup()
      '';

      settings = {
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
        plugin.prepend_previewers =
          map (mime: {
            inherit mime;
            run = "ouch";
          }) [
            "application/*zip"
            "application/x-tar"
            "application/x-bzip2"
            "application/x-7z-compressed"
            "application/x-rar"
            "application/x-xz"
            "application/xz"
          ];
      };

      keymap = {
        mgr.prepend_keymap = [
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
            on = "T";
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
          {
            on = ["g" "c"];
            run = "plugin vcs-files";
            desc = "Show Git file changes";
          }
        ];
      };

      theme = rec {
        mode = {
          normal_main = {
            fg = "black";
            bg = "blue";
          };
          normal_alt = {
            fg = "blue";
            bg = "black";
          };
          select_main = {
            fg = "black";
            bg = "red";
          };
          select_alt = {
            fg = "red";
            bg = "black";
          };
          unset_main = mode.select_main;
          unset_alt = mode.select_alt;
        };
        tabs = {
          active = mode.normal_main;
          inactive = mode.normal_alt;
        };
      };
    };
  };
}
