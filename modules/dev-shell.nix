{inputs, ...}: {
  imports = with inputs; [treefmt.flakeModule git-hooks.flakeModule];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    treefmt.programs.alejandra.enable = true;
    pre-commit.settings.hooks.treefmt.enable = true;
    pre-commit.settings.hooks.treefmt.package = config.treefmt.build.wrapper;
    devShells.default = pkgs.mkShell {
      inputsFrom = with config; [treefmt.build.devShell pre-commit.devShell];
      packages = with pkgs; [lua-language-server nil nixd];
    };
  };
}
