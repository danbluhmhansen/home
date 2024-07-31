{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    cachix # nix cache
    fd # find files
    sad # find & replace
    maple-mono-NF # monospace font
    vesktop # chat

    # TODO: move to devshell when pgrx supports it https://github.com/pgcentralfoundation/pgrx/pull/1683
    rustup
    pkg-config
    openssl
    usql
    cargo-outdated
  ];

  home.sessionVariables = {
    # TODO: remove when rust configuration is moved to a devshell
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
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
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    extraConfig = ''
      use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/sourced/cool-oneliners/dict.nu
    '';
  };

  programs.starship = {
    enableBashIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    settings = {
      git_branch.format = "[$symbol$branch(:$remote_branch)]($style)";
      git_branch.style = "";
      git_branch.symbol = " ";
      git_status.format = "([$all_status$ahead_behind]($style))";
      git_status.style = "";
    };
  };

  programs.direnv.nix-direnv.enable = true;

  programs.git = {
    userEmail = "00.pavers_dither@icloud.com";
    userName = "Dan Bluhm Hansen";
    signing.key = "0x077BBC8A99A747DD";
    signing.signByDefault = true;
    extraConfig.diff.algorithm = "histogram";
    extraConfig.init.defaultBranch = "dev";
    extraConfig.push.autoSetupRemote = true;
    delta.enable = true;
  };

  programs.bat.config.theme = "base16-256";

  programs.broot.settings = {
    icon_theme = "nerdfont";
    imports = lib.mkForce ["verbs.hjson" "skins/native-16.hjson"];
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
