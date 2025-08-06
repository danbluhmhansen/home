{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = with inputs.self.outputs.homeModules; [
    inputs.sops.homeManagerModules.sops
    broot
    firefox
    git
    gpg
    helix
    lazygit
    nushell
    starship
    yazi
    wezterm
  ];

  sops.defaultSopsFile = "${config.home.homeDirectory}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.age.generateKey = true;

  sops.secrets.cachix = {};
  sops.templates."cachix.dhall".content = ''
    { authToken = "${config.sops.placeholder.cachix}"
    , hostname = "https://cachix.org"
    , binaryCaches = [] : List { name : Text, secretKey : Text }
    }
  '';

  home.shellAliases = {
    la = "ls -a";
    ll = "ls -la";
  };

  home.packages = with pkgs; [cachix fd git-ignore ouch sad xh];

  home.file = {
    ".config/cachix/cachix.dhall".source = config.lib.file.mkOutOfStoreSymlink config.sops.templates."cachix.dhall".path;
  };

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

  programs.nh.flake = "${config.home.homeDirectory}/.config/home";
  programs.nh.clean.enable = true;
}
