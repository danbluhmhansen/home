{
  flake.modules.darwin.signal.homebrew.casks = [
    {
      name = "signal";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.signal = {pkgs, ...}: {home.packages = [pkgs.signal-desktop];};
}
