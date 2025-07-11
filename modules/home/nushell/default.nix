{pkgs, ...}: {
  home.packages = with pkgs; [vivid];
  programs.carapace.enable = true;
  programs.nushell.configFile.source = ./config.nu;
}
