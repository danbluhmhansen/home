{
  flake.overlays.opencode-v2 = final: prev: {
    opencode = final.callPackage ../../pkgs/opencode-v2/package.nix {};
    opencode-desktop = final.callPackage ../../pkgs/opencode-v2/desktop.nix {opencode = final.opencode;};
  };

  flake.modules.homeManager.opencode-desktop = {pkgs, ...}: {home.packages = [pkgs.opencode-desktop];};

  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;
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
