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
      Unit.Description = "Secure and free password manager for all of your devices";
      Unit.After = "dms.service";
      Service.ExecStart = lib.getExe pkgs.bitwarden-desktop;
      Service.Restart = "on-failure";
      Service.Slice = "app-graphical.slice";
      Install.WantedBy = ["dms.service"];
    };
  };
}
