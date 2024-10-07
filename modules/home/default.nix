{
  home.stateVersion = "24.05";
  imports = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [cachix fd sad];
        programs.home-manager.enable = true;
        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;
        programs.bat.enable = true;
        programs.ripgrep.enable = true;
        programs.fzf.enable = true;
        programs.bottom.enable = true;
        programs.bat.config.theme = "base16-256";
      }
    )
    ./broot.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./nushell
    ./yazi.nix
  ];
}
