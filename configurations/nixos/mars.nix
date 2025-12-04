{
  inputs,
  user,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  imports = [inputs.wsl.nixosModules.default];

  home-manager.sharedModules = [{services.gpg-agent.pinentry.package = pkgs.pinentry-curses;}];

  wsl.enable = true;
  wsl.defaultUser = user;
  wsl.usbip.enable = true;

  users.groups.plugdev = {};
  users.users.dan.extraGroups = ["plugdev"];

  services.pcscd.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", GROUP="plugdev", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407"
  '';
}
