{
  flake.modules.darwin.bitwarden.homebrew.casks = [
    {
      name = "bitwarden";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.bitwarden = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [pkgs.bitwarden-desktop];
    systemd.user.services.bitwarden-autostart = {
      Unit.Description = lib.pipe (builtins.readFile "${pkgs.bitwarden-desktop}/share/applications/bitwarden.desktop") [
        (builtins.split "\n")
        (builtins.filter builtins.isString)
        (builtins.filter (lib.hasPrefix "Comment="))
        builtins.head
        (lib.removePrefix "Comment=")
      ];
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.bitwarden-desktop;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
