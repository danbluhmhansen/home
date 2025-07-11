{
  programs.git = {
    userName = "Dan Bluhm Hansen";
    userEmail = "00.pavers_dither@icloud.com";
    delta.enable = true;
    signing.key = "0x077BBC8A99A747DD";
    signing.signByDefault = true;
    extraConfig.diff.algorithm = "histogram";
    extraConfig.init.defaultBranch = "dev";
    extraConfig.push.autoSetupRemote = true;
  };
}
