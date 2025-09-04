{ lib, ... }:
{
  disko.devices = {
    disk.nvme0n1 = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # Partition EFI (identique à Arch)
          efi = {
            name = "EFI";
            size = "512M";  # Taille typique pour une partition EFI
            type = "EF00";  # Code pour partition EFI système
            content = {
              type = "filesystem";
              format = "vfat";  # FAT32
              mountpoint = "/boot";  # Point de montage (comme sur Arch)
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          
          # Partition racine (comme sur Arch)
          root = {
            name = "ROOT";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";  # Ou btrfs, selon votre préférence
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}