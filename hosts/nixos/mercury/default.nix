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
        inputs.nur.modules.nixos.default
        inputs.disko.nixosModules.default
        {
          networking.hostName = "mercury";
          home-manager = {
            extraSpecialArgs = specialArgs;
            users.dan = {
              imports = with config.flake.modules.homeManager; [
                mercury

                # bitwarden
                chromium
                discord
                firefox
                ghostty
                mpv
                signal
                zen-browser

                awww
                mako
                walker
                waybar

                eza
                git
                gpg
                helix
                opencode
                starship
                yazi
                zellij
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

        ly
        niri
        nvidia
        pipewire

        nushell
        steam

        cloudflare-warp
        openssh
        plugdev
      ]);
  };
}
