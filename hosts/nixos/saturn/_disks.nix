{
  disko.devices = {
    disk.extbackup = {
      type = "disk";
      device = "/dev/disk/by-id/usb-Seagate_Expansion_HDD_00000000NT1FMXVK-0:0";
      content = {
        type = "gpt";
        partitions.luks = {
          label = "external-crypt";
          size = "100%";
          content = {
            type = "luks";
            name = "extbackup";
            # Never block boot when the disk is not attached.
            settings.crypttabExtraOpts = ["nofail"];
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "@data" = {
                  mountpoint = "/srv/external-data";
                  mountOptions = ["noatime" "nofail" "x-systemd.automount"];
                };
                "@backups" = {
                  mountpoint = "/srv/external-backups";
                  # The backup repository is created here on boot, so keep the
                  # automount from stalling the boot for the default timeout
                  # when the disk is not attached.
                  mountOptions = [
                    "noatime"
                    "nofail"
                    "x-systemd.automount"
                    "x-systemd.mount-timeout=30"
                  ];
                };
              };
            };
          };
        };
      };
    };
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            type = "EF00";
            name = "ESP";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings = {
                allowDiscards = true;
                crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
              };
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
