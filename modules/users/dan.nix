{inputs, ...}: {
  flake.modules.nixos.dan = {
    users.users.dan = {
      isNormalUser = true;
      createHome = true;
      home = "/home/dan";
      extraGroups = ["wheel" "networkmanager" "seat"];
    };
    home-manager.sharedModules = [inputs.self.modules.homeManager.dan];
  };

  flake.modules.nixos.dan-sops = {config, ...}: {
    sops.secrets.userpass.neededForUsers = true;
    users.users.dan.hashedPasswordFile = config.sops.secrets.userpass.path;
  };

  flake.modules.darwin.dan = {
    system.primaryUser = "dan";
    users.users.dan.home = "/Users/dan";
    home-manager.sharedModules = [inputs.self.modules.homeManager.dan];
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
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/dan"
        else "/home/dan"
      );
    home.packages = with pkgs;
      [cachix fd git-ignore gitu less ouch scooter xh]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [rustup maple-mono.NF];

    programs.nh.enable = true;
    programs.direnv.enable = true;
    programs.direnv.config.hide_env_diff = true;
    programs.direnv.nix-direnv.enable = true;
    programs.devenv.enable = true;
    programs.devenv.enableNushellIntegration = false;

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

  flake.modules.homeManager.mars = {pkgs, ...}: {
    home.packages = with pkgs; [dotnetCorePackages.sdk_10_0-bin powershell];
  };
}
