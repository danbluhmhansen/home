{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [discord maple-mono.NF sshfs];

  programs.git.extraConfig.credential.helper = "osxkeychain";

  programs.firefox.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
  programs.wezterm.enable = true;

  programs.bat.config.theme = "base16-256";

  programs.yazi.theme = rec {
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

  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

  launchd.agents.env.enable = true;
  launchd.agents.env.config = {
    Label = "env";
    RunAtLoad = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        launchctl setenv PASSWORD_STORE_DIR ${config.home.homeDirectory}/.local/share/pass
      ''
    ];
  };
}
