{pkgs, ...}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "273019910c1111a388dd20e057606016f4bd0d17";
    hash = "sha256-80mR86UWgD11XuzpVNn56fmGRkvj0af2cFaZkU8M31I=";
  };
in {
  programs.yazi.enable = true;
  programs.yazi.plugins = {
    diff = "${yazi-plugins}/diff.yazi";
    git = "${yazi-plugins}/git.yazi";
    jump-to-char = "${yazi-plugins}/jump-to-char.yazi";
    mount = "${yazi-plugins}/mount.yazi";
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
