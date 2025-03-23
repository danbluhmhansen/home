{
  flake,
  pkgs,
  config,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.linux
    ../../modules/home/starship.nix
    ../../modules/home/wezterm
  ];
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  nixGL.packages = inputs.nixgl.packages;

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = ["Maple Mono NF"];

  programs.git.extraConfig.credential.helper = "/usr/lib/git-core/git-credential-libsecret";
  programs.wezterm.package = config.lib.nixGL.wrap inputs.wezterm.packages.${pkgs.system}.default;
  programs.helix.package = inputs.helix.packages.${pkgs.system}.default;
  programs.yazi.package = inputs.yazi.packages.${pkgs.system}.default;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.defaultCacheTtl = 60;
  services.gpg-agent.maxCacheTtl = 120;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
}
