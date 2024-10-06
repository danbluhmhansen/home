{flake, ...}: {
  programs.git = {
    enable = true;
    userName = flake.config.me.fullname;
    userEmail = flake.config.me.email;
    delta.enable = true;
    signing.key = "0x077BBC8A99A747DD";
    signing.signByDefault = true;
    extraConfig.diff.algorithm = "histogram";
    extraConfig.init.defaultBranch = "dev";
    extraConfig.push.autoSetupRemote = true;
  };
}
