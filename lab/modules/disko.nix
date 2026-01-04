{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/ata-AGI120G06AI138_AGISAAXXK1002289";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                  };
                };
              };
            };
          };
        };
      };
      data = {
        device = "/dev/disk/by-id/ata-ST1000DM003-1CH162_W1D34CCN";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            storage = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "1000xlab" ];
                mountpoint = "/mnt/1000xlab";
                mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
              };
            };
          };
        };
      };
    };
  };
}
