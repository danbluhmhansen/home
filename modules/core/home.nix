{inputs, ...}: let
  common = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
in {
  flake.modules.nixos.core.home-manager = common;
  flake.modules.darwin.core.home-manager = common;
  flake.modules.homeManager.core = {
    imports = [inputs.nix-index-database.homeModules.nix-index];
    programs.home-manager.enable = true;
    programs.bash.enable = true;
    programs.zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
    };
    programs.nix-index-database.comma.enable = true;
  };
}
