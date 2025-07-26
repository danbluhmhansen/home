{pkgs, ...}: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    package = pkgs.darwin.linux-builder-x86_64;
  };
  ids.gids.nixbld = 30000;

  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.tilesize = 48;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.brews = ["podman"];
  homebrew.casks = [
    {
      name = "chromium";
      args = {
        appdir = "~/Applications";
        no_quarantine = true;
      };
    }
    {
      name = "hammerspoon";
      args = {appdir = "~/Applications";};
    }
    {
      name = "utm";
      args = {appdir = "~/Applications";};
    }
  ];
}
