{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    self.nixosModules.default
    {
      home-manager.sharedModules = [
        ({pkgs, ...}: {
          home.packages = with pkgs; [yubikey-manager];

          programs.helix.package = inputs.helix.packages.${pkgs.system}.default;

          programs.gpg.scdaemonSettings = {
            disable-ccid = true;
          };

          services.gpg-agent.enable = true;
          services.gpg-agent.enableSshSupport = true;
          services.gpg-agent.defaultCacheTtl = 60;
          services.gpg-agent.maxCacheTtl = 120;
          services.gpg-agent.pinentryPackage = pkgs.pinentry-curses;
        })
      ];
    }
  ];

  system.stateVersion = "24.05";
  networking.hostName = "mars";
  nixpkgs.hostPlatform = "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = "dan";
  wsl.usbip.enable = true;
  wsl.usbip.autoAttach = ["2-1"];

  users.groups.plugdev = {};
  users.users.${flake.config.me.username} = {
    extraGroups = ["plugdev"];
  };

  programs.ssh.startAgent = false;
  programs.ssh.knownHosts.github0 = {
    hostNames = ["github.com"];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

  services.pcscd.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", GROUP="plugdev", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407"
  '';
}
