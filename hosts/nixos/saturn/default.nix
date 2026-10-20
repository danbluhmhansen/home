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
        inputs.nur.modules.nixos.default
        inputs.disko.nixosModules.default
        {
          networking.hostName = "saturn";
          users.users.dan.linger = true;
          networking.firewall.allowedTCPPorts = [80 443];

          backup.enable = true;

          # Boot-unlock is declared in ./_disks.nix via disko.
          # Data directories for the containers in modules/containers/streaming.nix.
          systemd.tmpfiles.rules = [
            "d /srv/external-data/jellyfin 0755 dan users -"
            "d /srv/external-data/ombi 0755 dan users -"
            "d /srv/external-data/sonarr 0755 dan users -"
            "d /srv/external-data/radarr 0755 dan users -"
            "d /srv/external-data/bazarr 0755 dan users -"
            "d /srv/external-data/prowlarr 0755 dan users -"
            "d /srv/external-data/cleanuparr 0755 dan users -"
            "d /srv/external-data/qbittorrent 0755 dan users -"
            "d /srv/external-data/tvshows 0755 dan users -"
            "d /srv/external-data/movies 0755 dan users -"
            "d /srv/external-data/foundry 0755 dan users -"
            "d /srv/external-data/downloads 0755 dan users -"
          ];

          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                saturn

                eza
                git
                gpg
                helix
                starship
                yazi
                zellij

                actual
                authelia
                cv
                forgejo
                foundryvtt
                glance
                immich
                lldap
                metube
                oxicloud
                postgres
                redis
                sparkyfitness
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

        nushell

        openssh
        plugdev
        podman

        backup
      ]);
  };
}
