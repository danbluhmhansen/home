{
  pkgs,
  lib,
  ...
}: {
  home.username = "dan";
  home.homeDirectory = lib.mkForce "/Users/dan";
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.cachix # nix cache
    pkgs.fd # find files
    pkgs.sad # find & replace
    pkgs.maple-mono-NF # monospace font
    pkgs.vesktop # chat

    # TODO: move to devshell when pgrx supports it https://github.com/pgcentralfoundation/pgrx/pull/1683
    pkgs.rustup
    pkgs.pkg-config
    pkgs.openssl
    pkgs.usql
  ];

  home.sessionVariables = {
    # TODO: remove when rust configuration is moved to a devshell
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  # shells
  programs.zsh.enable = true;
  programs.nushell.enable = true;

  # misc
  programs.carapace.enable = true; # shell completions
  programs.gpg.enable = true; # crypt
  programs.starship.enable = true; # shell prompt

  # cli
  programs.git.enable = true;
  programs.bat.enable = true; # display files
  programs.ripgrep.enable = true; # search file content
  programs.fzf.enable = true; # fuzzy finder

  # tui
  programs.bottom.enable = true; # system monitor
  programs.broot.enable = true; # file tree view
  programs.helix.enable = true; # editor

  # gui
  programs.firefox.enable = true; # browser
  programs.wezterm.enable = true; # terminal

  programs.nushell = {
    configFile = {
      text = ''
        $env.config.show_banner = false
      '';
    };
    envFile = {
      text = ''
        def create_left_prompt [] {
          let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
              null => $env.PWD
              ''' => '~'
              $relative_pwd => ([~ $relative_pwd] | path join)
          }

          let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
          let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
          let path_segment = $"($path_color)($dir)"

          $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
        }

        def create_right_prompt [] {
          let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {
            ([(ansi rb) ($env.LAST_EXIT_CODE)] | str join)
          } else { "" }

          $last_exit_code
        }

        $env.PROMPT_COMMAND = {|| create_left_prompt }
        $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
      '';
    };
  };

  programs.starship = {
    enableBashIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    settings = {
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        style = "";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style))";
        style = "";
      };
    };
  };

  programs.git = {
    userEmail = "00.pavers_dither@icloud.com";
    userName = "Dan Bluhm Hansen";
    signing = {
      key = "0x077BBC8A99A747DD";
      signByDefault = true;
    };
    extraConfig = {
      diff.algorithm = "histogram";
      init.defaultBranch = "dev";
      push.autoSetupRemote = true;
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };

  programs.broot.settings = {
    imports = [
      "verbs.hjson"
      {
        file = "skins/catppuccin-mocha.hjson";
        luma = ["dark" "unknown"];
      }
      {
        file = "skins/white.hjson";
        luma = "light";
      }
    ];
    verbs = [
      {
        invocation = "hx";
        key = "enter";
        apply_to = "text_file";
        external = "/etc/profiles/per-user/dan/bin/nu ~/wz.nu {file}:{line}";
        # external = "$EDITOR {file}:{line}";
        leave_broot = false;
      }
    ];
  };

  programs.wezterm.extraConfig = builtins.readFile ./wezterm.lua;
}
