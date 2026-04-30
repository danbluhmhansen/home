{inputs, ...}: {
  flake.modules.nixos.keyring = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.keyring];
    security = {
      pam.services = {
        login.enableGnomeKeyring = true;
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      polkit.enable = true;
      sudo-rs.enable = true;
    };
  };
  flake.modules.homeManager.keyring = {pkgs, ...}: {
    home.packages = with pkgs; [gcr seahorse];
    services.gnome-keyring.enable = true;
  };
}
