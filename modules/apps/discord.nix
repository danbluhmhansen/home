{
  flake.modules.darwin.discord.homebrew.casks = [
    {
      name = "discord";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.discord = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [pkgs.discord];
    systemd.user.services.discord-autostart = {
      Unit.Description = lib.pipe (builtins.readFile "${pkgs.discord}/share/applications/discord.desktop") [
        (builtins.split "\n")
        (builtins.filter builtins.isString)
        (builtins.filter (lib.hasPrefix "GenericName="))
        builtins.head
        (lib.removePrefix "GenericName=")
      ];
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.discord;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
