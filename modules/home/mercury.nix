{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.outputs.homeModules; [niri];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [discord gcr libnotify pavucontrol signal-desktop sshfs systemctl-tui yubikey-manager];

  programs.alacritty.enable = true;
  programs.wezterm.enable = true;
  programs.firefox.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
  programs.sherlock.enable = true;
  programs.swaylock.enable = true;

  programs.firefox.nativeMessagingHosts = [pkgs.kdePackages.plasma-browser-integration];

  programs.git.extraConfig.credential.helper = let
    pkg = pkgs.git.override {withLibsecret = true;};
  in "${pkg}/bin/git-credential-libsecret";

  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

  services.gnome-keyring.enable = true;
  services.swaync.enable = true;
  services.swww.enable = true;
}
