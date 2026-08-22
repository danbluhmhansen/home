{
  flake.modules.darwin.obs.homebrew.casks = [{name = "obs";}];
  flake.modules.homeManager.obs = {
    pkgs,
    lib,
    ...
  }: {
    programs.obs-studio =
      {
        enable = true;
        plugins = [pkgs.obs-studio-plugins.droidcam-obs];
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {package = null;};
  };
}
