{ config, pkgs, username, hostname, ... }:

{

  # --- Boot ---
  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;
  };
  boot.supportedFilesystems = [ "btrfs" "nfs" "ntfs" ];

}
