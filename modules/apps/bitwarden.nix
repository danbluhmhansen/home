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
  };
}
