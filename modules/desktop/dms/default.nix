{inputs, ...}: {
  flake.modules.nixos.dms = {pkgs, ...}: {
    home-manager.sharedModules = [inputs.self.modules.homeManager.dms];
    environment.systemPackages = with pkgs; [
      accountsservice
      adw-gtk3
      catppuccin-cursors.mochaDark
      catppuccin-cursors.latteLight
      kdePackages.breeze-icons
    ];
    hardware.i2c.enable = true;
    programs.dms-shell = {enable = true;};
    programs.dsearch.enable = true;
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      logs.save = true;
    };
    xdg.icons.fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
  };

  flake.modules.nixos.dms-dan = {config, ...}: {
    environment.sessionVariables.TERMINAL = "ghostty";
    services.displayManager.dms-greeter.configHome = config.users.users.dan.home;
  };

  flake.modules.homeManager.dms = {
    config,
    pkgs,
    ...
  }: {
    home.file = {
      ".config/DankMaterialShell/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/desktop/dms/settings.json";
      ".local/share/icons/default/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
    };
  };
}
