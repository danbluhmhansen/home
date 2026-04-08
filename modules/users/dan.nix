{
  flake.modules.nixos.dan = {
    users.users.dan = {
      isNormalUser = true;
      createHome = true;
      home = "/home/dan";
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  flake.modules.nixos.dan-sops = {config, ...}: {
    sops.secrets.userpass.neededForUsers = true;
    users.users.dan.hashedPasswordFile = config.sops.secrets.userpass.path;
  };

  flake.modules.darwin.dan = {
    system.primaryUser = "dan";
    users.users.dan.home = "/Users/dan";
  };

  flake.modules.homeManager.dan = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.homeDirectory =
      lib.mkForce
      (
        if pkgs.stdenv.isDarwin
        then "/Users/dan"
        else "/home/dan"
      );
    home.shellAliases = {
      la = "ls -a";
      ll = "ls -la";
    };
    home.packages = with pkgs;
      [cachix devenv fd git-ignore gitu less ouch sad xh]
      ++ lib.optionals pkgs.stdenv.isDarwin [rustup maple-mono.NF];

    programs.nh.enable = true;
    programs.direnv.enable = true;
    programs.direnv.config.hide_env_diff = true;
    programs.direnv.nix-direnv.enable = true;

    programs.bat.enable = true;
    programs.bat.config.theme-dark = "Catppuccin Mocha";
    programs.bat.config.theme-light = "Catppuccin Latte";
    programs.bottom.enable = true;
    programs.fzf.enable = true;
    programs.ripgrep.enable = true;
    programs.zoxide.enable = true;

    programs.nh.flake = "${config.home.homeDirectory}/.config/home";
    programs.nh.clean.enable = true;
    programs.nh.clean.extraArgs = "--keep-since 14d --keep 5";
  };
}
