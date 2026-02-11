{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.self.outputs.homeModules; [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    niri
  ];

  fonts.fontconfig.enable = true;

  home.file = {
    ".icons/breeze".source = "${pkgs.kdePackages.breeze-icons}/share/icons/breeze";
    ".icons/default/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
    ".icons/catppuccin-mocha-dark-cursors/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
    ".icons/catppuccin-latte-light-cursors/cursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors/cursors";
  };

  home.packages = with pkgs; [
    discord
    gcr
    libnotify
    pywalfox-native
    signal-desktop
    sshfs
    systemctl-tui
    yubikey-manager
  ];

  programs.wezterm.enable = true;
  programs.ghostty.enable = true;
  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
  programs.dank-material-shell.enable = true;
  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [droidcam-obs];

  programs.chromium.package = pkgs.ungoogled-chromium;

  programs.git.settings.credential.helper = let
    pkg = pkgs.git.override {withLibsecret = true;};
  in "${pkg}/bin/git-credential-libsecret";

  programs.dank-material-shell = {
    systemd.enable = true;
    niri.includes.filesToInclude = ["alttab" "binds" "colors" "cursor" "layout" "outputs" "wpblur"];
    # systemd.target = "niri-session.service";
  };

  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

  services.gnome-keyring.enable = true;
  services.easyeffects.enable = true;
}
