let
  subs = ["https://nix-community.cachix.org" "https://danbluhmhansen.cachix.org" "https://helix.cachix.org"];
  common = {
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
        ];
      };
    };
    time.timeZone = "Europe/Copenhagen";
    programs.zsh.enable = true;
    services.tailscale.enable = true;
  };
in {
  flake.modules.nixos.core = {pkgs, ...}:
    common
    // {
      i18n.defaultLocale = "en_DK.UTF-8";
      i18n.extraLocaleSettings.LC_ALL = "en_DK.UTF-8";
      hardware.gpgSmartcards.enable = true;
      users.defaultUserShell = pkgs.zsh;
    };
  flake.modules.darwin.core =
    common
    // {
      # NOTE enable to bootstrap nix-rosetta-builder
      # nix.linux-builder = {
      #   enable = true;
      #   ephemeral = true;
      # };
      nix-rosetta-builder.onDemand = true;
      ids.gids.nixbld = 30000;
      programs.gnupg.agent.enable = true;
      programs.gnupg.agent.enableSSHSupport = true;
    };
}
