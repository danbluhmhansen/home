{pkgs, ...}: {
  imports = [
    ./broot.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./nushell
    ./yazi.nix
  ];

  home.stateVersion = "24.05";

  home.packages = with pkgs; [cachix fd sad tea termscp vivid];

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fzf.enable = true;
  programs.skim.enable = true;
  programs.bottom.enable = true;
  programs.zoxide.enable = true;
  programs.bat.config.theme = "base16-256";
}
