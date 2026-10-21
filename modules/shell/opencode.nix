{
  flake.modules.homeManager.opencode-desktop = {pkgs, ...}: {home.packages = [pkgs.opencode-desktop];};

  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;
      validateFiles.tui = true;
      validateFiles.config = true;
      settings = {
        permission = {
          external_directory = {
            "/nix/store/**" = "allow";
            "$HOME/.cargo/registry/**" = "allow";
            "$HOME/.cargo/git/checkouts/**" = "allow";
            "$HOME/.nuget/packages/**" = "allow";
          };
        };
      };
    };
  };
}
