{
  inputs,
  config,
  ...
}: let
  specialArgs = {inherit inputs;};
in {
  flake.nixosConfigurations.mercury = inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules =
      [
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.default
        {
          networking.hostName = "mercury";
          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                core
                mercury
                dan

                dms
                niri

                bitwarden
                chromium
                discord
                firefox
                ghostty
                mpv
                obs
                pipewire
                signal
                zed

                eza
                git
                gpg
                helix
                opencode
                starship
                yazi
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
        bluetooth
        dan
        dan-sops

        keyring

        dms
        niri
        nvidia
        pipewire

        steam

        openssh
        plugdev
      ]);
  };
}
