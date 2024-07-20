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
    pkgs.cargo-outdated
  ];

  home.file = {
    "hx.sh" = {
      executable = true;
      source = ./hx.sh;
    };
    "wz.nu".source = ./wz.nu;
  };

  home.sessionVariables = {
    DEFAULT_SHELL = "${pkgs.zsh}/bin/zsh";
    # TODO: remove when rust configuration is moved to a devshell
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  fonts.fontconfig.enable = true;

  launchd.agents.dark-notify.enable = true;
  launchd.agents.dark-notify.config = {
    Label = "dark-notify";
    RunAtLoad = true;
    KeepAlive = true;
    StandardErrorPath = "/Users/dan/dark-notify-err.log";
    StandardOutPath = "/Users/dan/dark-notify-out.log";
    ProgramArguments = ["/opt/homebrew/bin/dark-notify" "-c" "/bin/sh /Users/dan/hx.sh"];
  };

  programs.home-manager.enable = true;

  # shells
  programs.zsh.enable = true;
  programs.nushell.enable = true;

  # misc
  programs.carapace.enable = true; # shell completions
  programs.gpg.enable = true; # crypt
  programs.starship.enable = true; # shell prompt
  programs.direnv.enable = true; # load .env

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
    configFile.text = ''
      $env.config.show_banner = false
    '';
    envFile.source = ./env.nu;
    extraConfig = ''
      source ${pkgs.nu_scripts}/share/nu_scripts/sourced/cool-oneliners/dict.nu
    '';
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
        external = "nu ~/wz.nu {file}:{line}";
        leave_broot = false;
      }
    ];
  };

  programs.wezterm.extraConfig = builtins.readFile ./wezterm.lua;
}
