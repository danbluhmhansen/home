{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [self.darwinModules.default];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "jupiter";

  # For home-manager to work.
  users.users.${flake.config.me.username} = {
    home = "/Users/${flake.config.me.username}";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.tilesize = 48;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

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
  homebrew.brews = ["mpv" "podman"];
  homebrew.casks = [
    {
      name = "hammerspoon";
      args = {appdir = "~/Applications";};
    }
  ];
}
