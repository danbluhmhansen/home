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
      Unit.Description = "All-in-one cross-platform voice and text chat for gamers";
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.discord;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
