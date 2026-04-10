{inputs, ...}: {
  flake.modules.nixos.dms = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [accountsservice adw-gtk3];
    hardware.i2c.enable = true;
    programs.dms-shell = {
      enable = true;
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
    };
    programs.dsearch.enable = true;
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      logs.save = true;
    };
  };
  flake.modules.nixos.dms-dan = {config, ...}: {
    services.displayManager.dms-greeter.configHome = config.users.users.dan.home;
  };

  flake.modules.homeManager.dms = {pkgs, ...}: {
    home.file = {
      ".icons/breeze".source = "${pkgs.kdePackages.breeze-icons}/share/icons/breeze";
      ".icons/default/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
      ".icons/catppuccin-mocha-dark-cursors/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
      ".icons/catppuccin-latte-light-cursors/cursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors/cursors";
    };
  };
}
