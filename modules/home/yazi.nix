{pkgs, ...}: {
  home.file = {
    ".config/yazi/plugins/smart-filter.yazi/main.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/yazi-rs/plugins/0b9f325fe9d1edbc6d7893344cd308533ebd827a/smart-filter.yazi/init.lua";
      hash = "sha256-2iB0ADNf+oT4KJPQhXOo2McydZj4YL+I3jFUlkgjFc0=";
    };
  };
  programs.yazi.enable = true;
  programs.yazi.keymap = {
    manager.prepend_keymap = [
      {
        on = "F";
        run = "plugin smart-filter";
        desc = "Smart filter";
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
