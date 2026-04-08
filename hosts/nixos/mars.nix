{
  inputs,
  config,
  ...
}: let
  specialArgs = {inherit inputs;};
in {
  flake.nixosConfigurations.mars = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules =
      [
        inputs.home-manager.nixosModules.home-manager
        {
          networking.hostName = "mars";
          nixpkgs.hostPlatform = "x86_64-linux";
          programs.nix-ld.enable = true;
          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                core
                mars
                dan
                git
                gpg
                helix
                starship
                yazi
                zed
              ];
              programs.difftastic.options.background = "light";
              programs.helix.settings.theme.fallback = "catppuccin_latte";
              programs.opencode.enable = true;
            };
          };
        }
      ]
      ++ (with config.flake.modules.nixos; [
        core
        wsl
        plugdev
        dan
      ]);
  };
}
