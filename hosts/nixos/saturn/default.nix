{
  inputs,
  config,
  ...
}: let
  specialArgs = {inherit inputs;};
in {
  flake.nixosConfigurations.saturn = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules =
      [
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.default
        {
          networking.hostName = "saturn";
          users.users.dan.linger = true;
          networking.firewall.allowedTCPPorts = [80 443];
          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                core
                saturn
                dan

                git
                gpg
                helix
                starship
                yazi

                podman
                actual
                authelia
                cv
                forgejo
                foundryvtt
                glance
                lldap
                metube
                postgres
                stalwart
                streaming
                traefik
                vaultwarden
                wishlist
              ];
            };
          };
        }
        ./_disks.nix
        ./_hardware.nix
      ]
      ++ (with config.flake.modules.nixos; [
        core
        boot
        network
        fonts
        dan
        dan-sops

        openssh
        plugdev
        podman
      ]);
  };
}
