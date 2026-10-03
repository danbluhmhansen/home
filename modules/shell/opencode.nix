{inputs, ...}: {
  flake.modules.darwin.opencode = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.opencode];
    homebrew.brews = ["anomalyco/tap/opencode-v2"];
  };

  flake.modules.homeManager.opencode = {
    pkgs,
    lib,
    ...
  }: {
    programs.opencode =
      {
        enable = true;
        web.enable = !pkgs.stdenv.hostPlatform.isDarwin;
        settings = {
          permission = {
            external_directory = {
              "/nix/store/**" = "allow";
              "$HOME/.cargo/registry/**" = "allow";
              "$HOME/.cargo/git/checkouts/**" = "allow";
            };
          };
        };
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {package = null;};
  };
}
