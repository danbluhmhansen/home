{inputs, ...}: {
  flake.modules.nixos.dms = {
    imports = [inputs.dms.nixosModules.greeter];
    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/dan";
    };
  };

  flake.modules.homeManager.dms = {pkgs, ...}: {
    imports = [inputs.dms.homeModules.dank-material-shell inputs.dms.homeModules.niri];
    home.file = {
      ".icons/breeze".source = "${pkgs.kdePackages.breeze-icons}/share/icons/breeze";
      ".icons/default/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
      ".icons/catppuccin-mocha-dark-cursors/cursors".source = "${pkgs.catppuccin-cursors.mochaDark}/share/icons/catppuccin-mocha-dark-cursors/cursors";
      ".icons/catppuccin-latte-light-cursors/cursors".source = "${pkgs.catppuccin-cursors.latteLight}/share/icons/catppuccin-latte-light-cursors/cursors";
    };
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
      niri.includes.filesToInclude = ["alttab" "binds" "colors" "cursor" "layout" "outputs" "wpblur"];
      # systemd.target = "niri-session.service";
    };
  };
}
