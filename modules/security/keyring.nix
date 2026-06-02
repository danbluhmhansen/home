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
    services.gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };
  };

  flake.modules.nixos.keyring-wsl = {
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc" || action.id == "org.debian.pcsc-lite.access_card") {
          return "yes";
        }
      });
    '';
  };

  flake.modules.homeManager.keyring = {pkgs, ...}: {home.packages = with pkgs; [seahorse];};
}
