{
  flake.modules.darwin.zed.homebrew.casks = [
    {
      name = "zed";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.zed = {
    pkgs,
    lib,
    ...
  }: {
    programs.zed-editor = {enable = true;} // lib.optionalAttrs pkgs.stdenv.isDarwin {package = null;};
  };
}
