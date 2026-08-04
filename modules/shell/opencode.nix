{
  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;
      web.enable = true;
      settings = {
        permission = {
          external_directory = {
            "/nix/store/**" = "allow";
            "$HOME/.cargo/registry/**" = "allow";
            "$HOME/.cargo/git/checkouts/**" = "allow";
          };
        };
      };
    };
  };
}
