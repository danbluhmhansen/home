{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sherlock.homeManagerModules.default
    inputs.self.outputs.homeModules.hyprland
    inputs.self.outputs.homeModules.niri
    inputs.self.outputs.homeModules.sherlock
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [discord gcr libnotify pavucontrol sshfs yubikey-manager];

  programs.alacritty.enable = true;
  programs.wezterm.enable = true;
  programs.firefox.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
  programs.sherlock.enable = true;
  programs.swaylock.enable = true;

  programs.git.extraConfig.credential.helper = let
    pkg = pkgs.git.override {withLibsecret = true;};
  in "${pkg}/bin/git-credential-libsecret";

  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

  services.gnome-keyring.enable = true;
  services.hyprpaper.enable = pkgs.lib.mkForce false;
  services.swaync.enable = true;
  services.swww.enable = true;

  systemd.user.mounts.home-dan-saturn = {
    Unit.After = ["network-online.target"];
    Unit.Wants = ["network-online.target"];
    Install.WantedBy = ["default.target"];
    Mount.What = "saturn:/home/dan";
    Mount.Where = "${config.home.homeDirectory}/saturn";
    Mount.Type = "fuse.sshfs";
  };
  systemd.user.automounts.home-dan-saturn = {
    Install.WantedBy = ["default.target"];
    Automount.Where = "${config.home.homeDirectory}/saturn";
  };

  systemd.user.mounts.home-dan-glbe9300 = {
    Unit.After = ["network-online.target"];
    Unit.Wants = ["network-online.target"];
    Install.WantedBy = ["default.target"];
    Mount.What = "gl-be9300:/";
    Mount.Where = "${config.home.homeDirectory}/glbe9300";
    Mount.Type = "fuse.sshfs";
  };
  systemd.user.automounts.home-dan-glbe9300 = {
    Install.WantedBy = ["default.target"];
    Automount.Where = "${config.home.homeDirectory}/glbe9300";
  };

  wayland.windowManager.hyprland.enable = true;
}
