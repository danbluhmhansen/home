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
      Unit.Description = lib.pipe (builtins.readFile "${pkgs.signal-desktop}/share/applications/signal.desktop") [
        (builtins.split "\n")
        (builtins.filter builtins.isString)
        (builtins.filter (lib.hasPrefix "Comment="))
        builtins.head
        (lib.removePrefix "Comment=")
      ];
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.signal-desktop;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
