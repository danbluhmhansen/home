{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [./starship.nix];

  home.file = {
    ".config/wezterm/wezterm.lua".text = "local wezterm = require 'wezterm'\n" + builtins.readFile ./wezterm.lua;
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
      enable-ssh-support
      ttyname $GPG_TTY
      default-cache-ttl 60
      max-cache-ttl 120
    '';
    "Library/Application Support/org.dystroy.bacon/prefs.toml".text = inputs.nix-std.lib.serde.toTOML {
      keybindings = {
        esc = "back";
        g = "scroll-to-top";
        shift-g = "scroll-to-bottom";
        j = "scroll-lines(1)";
        k = "scroll-lines(-1)";
        h = "scroll-pages(-1)";
        l = "scroll-pages(1)";
      };
    };
  };

  home.packages = with pkgs; [maple-mono.NF ouch pinentry_mac];

  launchd.agents.env.enable = true;
  launchd.agents.env.config = {
    Label = "env";
    RunAtLoad = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        launchctl setenv PASSWORD_STORE_DIR /Users/${flake.config.me.username}/.local/share/pass
        launchctl setenv HOMEBREW_PREFIX /opt/homebrew
        launchctl setenv HOMEBREW_CELLAR /opt/homebrew/Cellar
        launchctl setenv HOMEBREW_REPOSITORY /opt/homebrew
      ''
    ];
  };

  launchd.agents.gpg-agent.enable = true;
  launchd.agents.gpg-agent.config = {
    Label = "gpg-agent";
    RunAtLoad = true;
    KeepAlive = false;
    ProgramArguments = ["/etc/profiles/per-user/${flake.config.me.username}/bin/gpg-connect-agent" "/bye"];
  };

  launchd.agents.gpg-agent-symlink.enable = true;
  launchd.agents.gpg-agent-symlink.config = {
    Label = "gpg-agent-symlink";
    RunAtLoad = true;
    ProgramArguments = ["/bin/sh" "-c" "/bin/ln -sf $HOME/.gnupg/S.gpg-agent.ssh $SSH_AUTH_SOCK"];
  };

  programs.zsh.enable = true;
  programs.zsh.profileExtra = ''eval "$(/opt/homebrew/bin/brew shellenv)"'';

  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
}
