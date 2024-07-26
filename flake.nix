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

            programs.gnupg.agent.enable = true;
            programs.gnupg.agent.enableSSHSupport = true;

            programs.ssh.knownHosts.github0 = {
              hostNames = ["github.com"];
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
            };
            programs.ssh.knownHosts.github1 = {
              hostNames = ["github.com"];
              publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
            };
            programs.ssh.knownHosts.github2 = {
              hostNames = ["github.com"];
              publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=";
            };

            programs.ssh.knownHosts.saturn0 = {
              hostNames = ["192.168.0.113"];
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKKrNe2ufRlqAZyS++ItBxothX3P5hUScEVHckJTpD8";
            };
            programs.ssh.knownHosts.saturn1 = {
              hostNames = ["192.168.0.113"];
              publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/xHSstPiGmegjfmlpoj7tHHAPvSDXqYREL9u7Uamyx+319dlV9MKz8JqRCQBaulkrVdzXentMLHl09oGtSdgVKL4NORCLkpY4HLVWAIu4d8X0TR4/Bepnl1t788ZZBk2z+XsjoB8VPIPrS28OXfEzv9km9/xhdIAZ92MmLrn8vcFPzIvvWi1FOynz7FycA3uBK/ekvZa7THefiMQy14rpHBVRH57epKmsyhJCgTkA2dowPWqgv+mXTX/dsQHPYtMma3LnGBe9cZylkPOXIkMClk1KksUlAF2wpteF5Ff/dPfkR3/h870nsjTS8nbJbUOLrXE45l6yKZURy5EhEA0CwSDMl6h6WbDPIBAqccL65mnI5UpwznV3PRk1YccvKaaKdF6y3VpKQWFj+KM22O9Vbe3QmoEHUgs8csTjRMbUWZAzllbKp2lbC2WdXK/QYgYEn1AgbL5xVObu7iFrIXn/k5jYTRwYLkaTs3DfVyv25OXEWj8bKyQDaH+OF0goWdc=";
            };
            programs.ssh.knownHosts.saturn2 = {
              hostNames = ["192.168.0.113"];
              publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPJq/2Nq4owYKsIbZBCQywNjiXqHYjTQjbWrvAcEcDaNThrzRRZRkwxZEB8gQ0tHirpb61ucLaHB6ENrBJ3ThYE=";
            };

            homebrew.enable = true;
            homebrew.onActivation.cleanup = "zap";
            homebrew.casks = [
              {
                name = "hammerspoon";
                args = {appdir = "~/Applications";};
              }
            ];
          };
        };

        # All home-manager configurations are kept here.
        homeModules = {
          # Common home-manager configuration shared between Linux and macOS.
          common = {pkgs, ...}: {
            home.username = user;
            home.file."wz.nu".source = ./wz.nu;
          };
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
              ".hammerspoon/init.lua".source = ./hammerspoon.lua;
              ".hammerspoon/Spoons/ReloadConfiguration.spoon".source = pkgs.fetchzip {
                url = "https://github.com/Hammerspoon/Spoons/raw/c53546e00552451e077677a92eb1646c65acdca1/Spoons/ReloadConfiguration.spoon.zip";
                hash = "sha256-kNyFHP3i1O4VhZQL2Ief6002TrvXzT4doZ9w8X5z6C0=";
              };
            };

            programs.zsh.enable = true;
          };
        };
      };

      perSystem = {
        self',
        pkgs,
        ...
      }: {
        packages.default = self'.packages.activate;

        devShells.default = pkgs.mkShell {
          inputsFrom = [];
          packages = with pkgs; [alejandra lua-language-server nil];
        };
      };
    };
}
