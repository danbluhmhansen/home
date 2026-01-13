{
  inputs,
  pkgs,
  user,
  ...
}: {
  home.stateVersion = "25.11";
  home.username = user;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${user}"
    else "/home/${user}";

  home.sessionVariables.PASSWORD_STORE_DIR =
    if pkgs.stdenv.isDarwin
    then "/Users/${user}/.local/share/pass"
    else "/home/${user}/.local/share/pass";

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.zsh = {
    autocd = true;
    autosuggestion.enable = true;
  };

  programs.gpg.scdaemonSettings.disable-ccid = true;

  programs.helix.package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.defaultCacheTtl = 60;
  services.gpg-agent.maxCacheTtl = 120;
}
