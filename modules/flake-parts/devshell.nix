{...}: {
  imports = [];
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "nixos-config-shell";
      meta.description = "Dev environment for nixos-config";
      packages = with pkgs; [alejandra lua-language-server nil];
    };
  };
}
