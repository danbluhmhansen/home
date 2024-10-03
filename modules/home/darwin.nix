{
  imports = [
    (
      {
        pkgs,
        flake,
        ...
      }: {
        home.file = {
          ".gnupg/gpg-agent.conf".text = ''
            pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
            enable-ssh-support
            default-cache-ttl 60
            max-cache-ttl 120
          '';
        };

        home.packages = with pkgs; [pinentry_mac pueue];

        launchd.agents.pueue.enable = true;
        launchd.agents.pueue.config = {
          Label = "pueue";
          LimitLoadToSessionType = "Aqua Background LoginWindow StandardIO System";
          RunAtLoad = true;
          StandardErrorPath = "/Users/${flake.config.me.username}/.cache/pueue/err.log";
          StandardOutPath = "/Users/${flake.config.me.username}/.cache/pueue/out.log";
          ProgramArguments = ["${pkgs.pueue}/bin/pueud" "--verbose"];
        };

        programs.zsh.enable = true;
        programs.zsh.profileExtra = ''eval "$(/opt/homebrew/bin/brew shellenv)"'';
      }
    )
  ];
}
