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
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.signal-desktop];
  };
}
