{
  flake.modules.nixos.keyring = {
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
    home.packages = [pkgs.gcr];
    services.gnome-keyring.enable = true;
  };
}
