{
  inputs,
  user,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";

  imports = [inputs.wsl.nixosModules.default];

  home-manager.sharedModules = [
    {
      services.gpg-agent.pinentry.package = pkgs.pinentry-curses;
      programs.git.settings.delta.light = true;
      programs.helix.settings.theme.fallback = "catppuccin_latte";
      programs.opencode.enable = true;
    }
  ];

  wsl.enable = true;
  wsl.defaultUser = user;
  wsl.usbip.enable = true;

  users.groups.plugdev = {};
  users.users.dan.extraGroups = ["plugdev"];

  programs.nix-ld.enable = true;

  services.pcscd.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", GROUP="plugdev", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407"
  '';
}
