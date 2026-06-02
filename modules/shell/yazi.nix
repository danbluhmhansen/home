{inputs, ...}: {
  flake.modules.homeManager.yazi = {pkgs, ...}: {
    programs.yazi = {
      enable = true;

      plugins = with pkgs.yaziPlugins; {
        inherit diff git jump-to-char mount ouch smart-enter smart-filter sudo toggle-pane vcs-files;
      };

      flavors = {
        catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
        catppuccin-mocha = "${inputs.yazi-flavors}/catppuccin-mocha.yazi";
      };

      theme.flavor.dark = "catppuccin-mocha";
      theme.flavor.light = "catppuccin-latte";

      initLua = ''
        require("git"):setup()
      '';

      settings = {
        plugin.prepend_fetchers = [
          {
            group = "git";
            url = "*";
            run = "git";
          }
          {
            group = "git";
            url = "*/";
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
          {
            on = ["R" "p" "p"];
            run = "plugin sudo -- paste";
            desc = "sudo paste";
          }
          {
            on = ["R" "P"];
            run = "plugin sudo -- paste --force";
            desc = "sudo paste";
          }
          {
            on = ["R" "r"];
            run = "plugin sudo -- rename";
            desc = "sudo rename";
          }
          {
            on = ["R" "p" "l"];
            run = "plugin sudo -- link";
            desc = "sudo link";
          }
          {
            on = ["R" "p" "r"];
            run = "plugin sudo -- link --relative";
            desc = "sudo link relative path";
          }
          {
            on = ["R" "p" "L"];
            run = "plugin sudo -- hardlink";
            desc = "sudo hardlink";
          }
          {
            on = ["R" "a"];
            run = "plugin sudo -- create";
            desc = "sudo create";
          }
          {
            on = ["R" "d"];
            run = "plugin sudo -- remove";
            desc = "sudo trash";
          }
          {
            on = ["R" "D"];
            run = "plugin sudo -- remove --permanently";
            desc = "sudo delete";
          }
          {
            on = ["R" "m"];
            run = "plugin sudo -- chmod";
            desc = "sudo chmod";
          }
        ];
      };
    };
  };
}
