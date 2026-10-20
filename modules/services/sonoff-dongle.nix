{
  flake.modules.nixos.sonoff-dongle = {
    # The SONOFF Dongle Max (Dongle-M) is a USB Zigbee/Thread radio that Home
    # Assistant talks to over a serial port. It is bound to the "plugdev"
    # group, which the "dan" user is a member of, so the Home Assistant
    # container can open it.
    #
    # The device is owned by "dan" as well. The container runs rootless, so
    # the owner of the device inside the container is the owner on the host
    # translated through the user namespace. The owner of the device is
    # "nobody" inside the container otherwise, and the container cannot open
    # it.
    #
    # The symlink gives the device a stable name. Without it the container
    # would depend on the order in which the kernel enumerates ttyUSB
    # devices, which changes when other USB serial devices are plugged in.
    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", OWNER="dan", MODE="0660", GROUP="plugdev", SYMLINK+="sonoff-dongle-m"
    '';
  };
}
