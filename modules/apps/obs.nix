{
  flake.modules.darwin.obs.homebrew.casks = [{name = "obs";}];
  flake.modules.homeManager.obs = {pkgs, ...}: {
    programs.obs-studio.enable = true;
    programs.obs-studio.plugins = [pkgs.obs-studio-plugins.droidcam-obs];
  };
}
