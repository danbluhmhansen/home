{
  inputs,
  user,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  imports = [inputs.wsl.nixosModules.default];

  home-manager.sharedModules = [
    {
      programs.git.delta.options.light = true;
      programs.helix.settings.theme = "catppuccin_latte";
    }
  ];

  wsl.enable = true;
  wsl.defaultUser = user;
  wsl.usbip.enable = true;
  wsl.usbip.autoAttach = ["2-1"];

  users.groups.plugdev = {};
  users.users.dan.extraGroups = ["plugdev"];

  programs.ssh.startAgent = false;

  services.pcscd.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", GROUP="plugdev", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407"
  '';
}
