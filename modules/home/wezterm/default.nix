{pkgs, ...}: {
  home.packages = with pkgs; [maple-mono-NF];
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
