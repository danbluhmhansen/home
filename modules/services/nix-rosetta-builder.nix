{inputs, ...}: {
  flake.modules.darwin.nix-rosetta-builder = {
    imports = [inputs.rosetta-builder.darwinModules.default];
    # NOTE enable to bootstrap nix-rosetta-builder
    # nix.linux-builder = {
    #   enable = true;
    #   ephemeral = true;
    # };
    nix-rosetta-builder.onDemand = true;
    ids.gids.nixbld = 30000;
  };
}
