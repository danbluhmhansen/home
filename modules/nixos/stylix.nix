{
  pkgs,
  user,
  ...
}: {
  stylix = {
    base16Scheme = pkgs.lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = pkgs.lib.mkDefault "dark";
    cursor.package = pkgs.lib.mkDefault pkgs.catppuccin-cursors.mochaDark;
    cursor.name = pkgs.lib.mkDefault "catppuccin-mocha-dark-cursors";
    cursor.size = 24;
    fonts = {
      monospace.package = pkgs.maple-mono.NF;
      monospace.name = "Maple Mono NF";
    };
  };

  home-manager.sharedModules = [
    {
      stylix = {
        icons.enable = true;
        icons.package = pkgs.kdePackages.breeze-icons;
        icons.dark = "breeze-dark";
        icons.light = "breeze";
        targets.firefox.profileNames = [user];
        targets.helix.enable = false;
        targets.niri.enable = false;
        targets.qt.platform = "qtct";
      };
    }
  ];
}
