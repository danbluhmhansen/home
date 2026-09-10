{inputs, ...}: let
  subs = [
    "https://nix-community.cachix.org"
    "https://danbluhmhansen.cachix.org"
    "https://helix.cachix.org"
    "https://devenv.cachix.org"
    "https://cachix.cachix.org"
  ];
  common = {
    nixpkgs.overlays = with inputs; [devenv.overlays.default helix.overlays.default];
    nixpkgs.config.allowUnfree = true;
    nix = {
      channel.enable = false;
      settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["@admin" "@wheel"];
        trusted-substituters = subs;
        extra-substituters = subs;
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "danbluhmhansen.cachix.org-1:0qTEsQt253LH3OJC7oxZSjSIf+6vB+l2scs1r+DnM+I="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        ];
      };
    };
    time.timeZone = "Europe/Copenhagen";
    programs.zsh.enable = true;
    services.tailscale.enable = true;
  };
in {
  flake.modules.nixos.core = {
    pkgs,
    lib,
    ...
  }:
    lib.recursiveUpdate common
    {
      i18n.defaultLocale = "en_DK.UTF-8";
      i18n.extraLocaleSettings.LC_ALL = "en_DK.UTF-8";
      hardware.gpgSmartcards.enable = true;
      users.defaultUserShell = pkgs.zsh;
      programs.nix-ld.enable = true;
    };
  flake.modules.darwin.core = common;
}
