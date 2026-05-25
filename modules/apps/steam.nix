{inputs, ...}: {
  flake.modules.nixos.steam = {pkgs, ...}: {
    home-manager.sharedModules = [inputs.self.modules.homeManager.steam];
    hardware.steam-hardware.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = ["--adaptive-sync" "--hdr-enabled" "--rt"];
    };
    programs.steam = {
      enable = true;
      extraPackages = [pkgs.hidapi];
      gamescopeSession.enable = true;
      gamescopeSession.steamArgs = ["-tenfoot" "-pipewire-dmabuf"];
    };
  };
  flake.modules.darwin.steam.homebrew.casks = [
    {
      name = "steam";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.steam = {
    pkgs,
    lib,
    ...
  }: {
    systemd.user.services.steam-autostart = {
      Unit.Description = lib.pipe (builtins.readFile "${pkgs.steam}/share/applications/steam.desktop") [
        (builtins.split "\n")
        (builtins.filter builtins.isString)
        (builtins.filter (lib.hasPrefix "Comment="))
        builtins.head
        (lib.removePrefix "Comment=")
      ];
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.steam;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
