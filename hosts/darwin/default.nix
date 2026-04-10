{
  inputs,
  jupiter,
  ...
}: let
  specialArgs = {inherit inputs;};
in {
  flake.darwinConfigurations = {
    jupiter = inputs.darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [(jupiter {includeRosettaBuilder = true;})];
    };
    jupiter-ci = inputs.darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [(jupiter {includeRosettaBuilder = false;})];
    };
  };
}
