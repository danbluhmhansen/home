{
  flake.modules.darwin.discord.homebrew.casks = [
    {
      name = "discord";
      args.appdir = "~/Applications";
    }
  ];
  flake.modules.homeManager.discord = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.discord];
  };
}
