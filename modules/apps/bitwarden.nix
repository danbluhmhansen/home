{
  flake.modules.darwin.bitwarden.homebrew.casks = [
    {
      name = "bitwarden";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.bitwarden = {pkgs, ...}: {home.packages = [pkgs.bitwarden-desktop];};
}
