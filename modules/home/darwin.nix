{pkgs, ...}: {
  home.packages = with pkgs; [discord maple-mono.NF ouch sshfs];

  programs.git.extraConfig.credential.helper = "osxkeychain";

  programs.firefox.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
  programs.wezterm.enable = true;

  programs.bat.config.theme = "base16-256";
  programs.helix.settings.theme = "theme";

  programs.gitui.theme = ''
    (
      selection_bg: Some("Black"),
      cmdbar_bg: Some("Reset"),
      cmdbar_extra_lines_bg: Some("Reset"),
    )
  '';

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

  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

  launchd.agents.env.enable = true;
  launchd.agents.env.config = {
    Label = "env";
    RunAtLoad = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        launchctl setenv PASSWORD_STORE_DIR /Users/dan/.local/share/pass
      ''
    ];
  };
}
