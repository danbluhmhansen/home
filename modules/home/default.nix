{
  home.stateVersion = "24.05";
  imports = [
    (
      {
        flake,
        pkgs,
        ...
      }: {
        home.packages = with pkgs; [cachix fd sad termscp usql vivid];
        programs.home-manager.enable = true;
        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;
        programs.bat.enable = true;
        programs.ripgrep.enable = true;
        programs.fzf.enable = true;
        programs.skim.enable = true;
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
