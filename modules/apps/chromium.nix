{
  flake.modules.darwin.chromium.homebrew.casks = [
    {
      name = "chromium";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.chromium = {
    pkgs,
    lib,
    ...
  }: {programs.chromium = {enable = true;} // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {package = null;};};
}
