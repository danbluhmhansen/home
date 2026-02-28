{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;

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
      name = "bitwarden";
      args.appdir = "~/Applications";
    }
    {
      name = "chromium";
      args = {
        appdir = "~/Applications";
        no_quarantine = true;
      };
    }
    {
      name = "discord";
      args.appdir = "~/Applications";
    }
    {
      name = "ghostty";
      args.appdir = "~/Applications";
    }
    {
      name = "hammerspoon";
      args.appdir = "~/Applications";
    }
    {
      name = "macfuse@dev";
      args.appdir = "~/Applications";
    }
    {name = "obs";}
    {
      name = "signal";
      args.appdir = "~/Applications";
    }
    {
      name = "steam";
      args.appdir = "~/Applications";
    }
    {
      name = "zed";
      args.appdir = "~/Applications";
    }
  ];
}
