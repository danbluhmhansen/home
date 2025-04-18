{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.linux
    ../../modules/home/starship.nix
  ];

  home.username = "dan";
  home.homeDirectory = "/home/dan";

  home.file = {
    ".config/wezterm/wezterm.lua".text = "local wezterm = require 'wezterm'\n" + builtins.readFile ../../modules/home/wezterm.lua;
  };

  home.packages = with pkgs; [maple-mono.NF ouch];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = ["Maple Mono NF"];

  programs.git.extraConfig.credential.helper = "/usr/lib/git-core/git-credential-libsecret";
  programs.helix.package = inputs.helix.packages.${pkgs.system}.default;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;

  programs.ssh.enable = true;
  programs.ssh.matchBlocks."192.168.0.113" = {
    user = "dan";
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.defaultCacheTtl = 60;
  services.gpg-agent.maxCacheTtl = 120;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
}
