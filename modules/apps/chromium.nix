{
  flake.modules.darwin.chromium.homebrew.casks = [
    {
      name = "chromium";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.chromium = {pkgs, ...}: {
    programs.chromium.enable = true;
    programs.chromium.package =
      if pkgs.stdenv.isDarwin
      then null
      else pkgs.ungoogled-chromium;
  };
}
