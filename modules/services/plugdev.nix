{
  flake.modules.nixos.plugdev = {
    users.groups.plugdev = {};
    users.users.dan.extraGroups = ["plugdev"];
    services.pcscd.enable = true;
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", GROUP="plugdev", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="045e", MODE="0660", GROUP="plugdev", SYMLINK+="webusb"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0170", MODE="0660", GROUP="plugdev", SYMLINK+="webusb"
    '';
  };
}
