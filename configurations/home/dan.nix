{
  inputs,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";
  home.username = "dan";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/dan"
    else "/home/dan";

  home.sessionVariables.PASSWORD_STORE_DIR =
    if pkgs.stdenv.isDarwin
    then "/Users/dan/.local/share/pass"
    else "/home/dan/.local/share/pass";

  home.packages = with pkgs; [termscp];

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.zsh = {
    autocd = true;
    autosuggestion.enable = true;
  };

  programs.gpg.scdaemonSettings.disable-ccid = true;

  programs.helix.package = inputs.helix.packages.${pkgs.system}.default;

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.defaultCacheTtl = 60;
  services.gpg-agent.maxCacheTtl = 120;
}
