{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = with inputs.self.outputs.homeModules; [
    inputs.sops.homeManagerModules.sops
    inputs.nix-index-database.homeModules.nix-index
    broot
    firefox
    git
    gpg
    helix
    lazygit
    nushell
    sherlock
    starship
    yazi
    wezterm
  ];

  sops.defaultSopsFile =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/Library/Application Support/sops/secrets/main.yml"
    else "${config.home.homeDirectory}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt"
    else "${config.home.homeDirectory}/.config/sops/age/keys.txt";
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

  home.packages = with pkgs; [cachix fd git-ignore less ouch sad xh];

  home.file = {
    ".config/cachix/cachix.dhall".source = config.lib.file.mkOutOfStoreSymlink config.sops.templates."cachix.dhall".path;
  };

  programs.nh.enable = true;
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.delta.enable = true;
  programs.direnv.enable = true;
  programs.direnv.config.hide_env_diff = true;
  programs.direnv.nix-direnv.enable = true;
  programs.nix-index-database.comma.enable = true;

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
