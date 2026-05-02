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
        inputs.nur.modules.nixos.default
        {
          networking.hostName = "mars";
          nixpkgs.hostPlatform = "x86_64-linux";
          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                mars
                eza
                git
                gpg
                helix
                opencode
                starship
                yazi
                zed
              ];
              programs.difftastic.options.background = "light";
              programs.helix.settings.theme.fallback = "catppuccin_latte";
            };
          };
        }
      ]
      ++ (with config.flake.modules.nixos; [
        core
        wsl
        plugdev
        dan
        nushell
      ]);
  };
}
