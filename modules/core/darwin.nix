{
  flake.modules.darwin.core = {
    security.pam.services.sudo_local.touchIdAuth = true;
    system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    system.defaults.dock.autohide = true;
    system.defaults.dock.mru-spaces = false;
    system.defaults.dock.show-recents = false;
    system.defaults.dock.tilesize = 48;
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;
  };
}
