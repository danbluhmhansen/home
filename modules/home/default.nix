{
  inputs,
  pkgs,
  ezModules,
  ...
}: {
  imports = with ezModules; [
    inputs.sops.homeManagerModules.sops
    broot
    firefox
    git
    gpg
    helix
    lazygit
    nushell
    starship
    swaync
    yazi
    waybar
    wezterm
  ];

  home.shellAliases = {
    la = "ls -a";
    ll = "ls -la";
  };

  home.packages = with pkgs; [cachix fd git-ignore sad xh];

  programs.nh.enable = true;
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.broot.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.helix.enable = true;
  programs.lazygit.enable = true;
  programs.nushell.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;

  programs.nh.flake =
    if pkgs.stdenv.isDarwin
    then "/Users/dan/.config/home"
    else "/home/dan/.config/home";
  programs.nh.clean.enable = true;
}
