{
  flake.modules.darwin.signal.homebrew.casks = [
    {
      name = "signal";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.signal = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [pkgs.signal-desktop];
    systemd.user.services.signal-autostart = {
      Unit.Description = "Private messaging from your desktop";
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.signal-desktop;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
