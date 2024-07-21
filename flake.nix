{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ {
    self,
    home-manager,
    flake-parts,
    nixos-flake,
    firefox-darwin,
    nur,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      imports = [nixos-flake.flakeModule];

      flake = let
        user = "dan";
      in {
        # Configurations for Linux (NixOS) machines
        nixosConfigurations = {
          jupiter = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.common # See below for "nixosModules"!
              self.nixosModules.linux
              # Your machine's configuration.nix goes here
              ({pkgs, ...}: {
                # TODO: Put your /etc/nixos/hardware-configuration.nix here
                boot.loader.grub.device = "nodev";
                fileSystems."/" = {
                  device = "/dev/disk/by-label/nixos";
                  fsType = "btrfs";
                };
                system.stateVersion = "24.05";
              })
              # Your home-manager configuration
              self.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${user} = {
                  imports = [
                    self.homeModules.common # See below for "homeModules"!
                    self.homeModules.linux
                    ./home.nix
                    ./firefox.nix
                    ./helix.nix
                    ./gpg.nix
                  ];
                  home.stateVersion = "24.05";
                };
              }
            ];
          };
        };

        # Configurations for macOS machines
        darwinConfigurations = {
          jupiter = self.nixos-flake.lib.mkMacosSystem {
            nixpkgs.hostPlatform = "aarch64-darwin";
            imports = [
              self.nixosModules.common # See below for "nixosModules"!
              self.nixosModules.darwin
              # Your machine's configuration.nix goes here
              ({pkgs, ...}: {
                # Used for backwards compatibility, please read the changelog before changing.
                # $ darwin-rebuild changelog
                system.stateVersion = 4;
              })
              # Your home-manager configuration
              self.darwinModules_.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                nixpkgs.overlays = [firefox-darwin.overlay];
                home-manager.users.${user} = {
                  imports = [
                    self.homeModules.common # See below for "homeModules"!
                    self.homeModules.darwin
                    ./home.nix
                    ./firefox.nix
                    ./helix.nix
                    ./gpg.nix
                    nur.hmModules.nur
                  ];
                  home.stateVersion = "24.05";
                };
              }
            ];
          };
        };

        # All nixos/nix-darwin configurations are kept here.
        nixosModules = {
          # Common nixos/nix-darwin configuration shared between Linux and macOS.
          common = {pkgs, ...}: {
            nix.settings.experimental-features = "nix-command flakes";
            system.configurationRevision = self.rev or self.dirtyRev or null;
          };
          # NixOS specific configuration
          linux = {pkgs, ...}: {
            users.users.${user}.isNormalUser = true;
          };
          # nix-darwin specific configuration
          darwin = {pkgs, ...}: {
            services.nix-daemon.enable = true;
            programs.zsh.enable = true;

            security.pam.enableSudoTouchIdAuth = true;
            system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
            system.defaults.dock.mru-spaces = false;
            system.defaults.dock.show-recents = false;
            system.defaults.dock.tilesize = 48;
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToControl = true;

            homebrew.enable = true;
            homebrew = {
              brews = ["cormacrelf/tap/dark-notify"];
              taps = ["cormacrelf/tap"];
            };
          };
        };

        # All home-manager configurations are kept here.
        homeModules = {
          # Common home-manager configuration shared between Linux and macOS.
          common = {pkgs, ...}: {home.username = user;};
          # home-manager config specific to NixOS
          linux = {
            pkgs,
            lib,
            ...
          }: {
            home.homeDirectory = lib.mkForce "/home/${user}";
          };
          # home-manager config specific to Darwin
          darwin = {
            pkgs,
            lib,
            ...
          }: {
            home.homeDirectory = lib.mkForce "/Users/${user}";

            home.file = {
              "hx.sh" = {
                executable = true;
                source = ./hx.sh;
              };
            };

            home.sessionVariables = {
              DEFAULT_SHELL = "${pkgs.zsh}/bin/zsh";
            };

            launchd.agents.dark-notify.enable = true;
            launchd.agents.dark-notify.config = {
              Label = "dark-notify";
              RunAtLoad = true;
              KeepAlive = true;
              StandardErrorPath = "/Users/${user}/dark-notify-err.log";
              StandardOutPath = "/Users/${user}/dark-notify-out.log";
              ProgramArguments = ["/opt/homebrew/bin/dark-notify" "-c" "/bin/sh /Users/${user}/hx.sh"];
            };

            programs.zsh.enable = true;
          };
        };
      };
    };
}
