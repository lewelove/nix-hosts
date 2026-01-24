{ config, lib, pkgs, modulesPath, username, ... }:

{

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # --- System Drives ---

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/aace99ed-5d25-4cf6-98a2-631459ae5fa2";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/aace99ed-5d25-4cf6-98a2-631459ae5fa2";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/aace99ed-5d25-4cf6-98a2-631459ae5fa2";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6125-B937";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # --- Data Drives ---

  fileSystems."/run/media/${username}/1000xhome" = {
    device = "/dev/disk/by-uuid/27b9a1ab-0bb3-4e2f-bc9b-7c4a227dbb2f";
    fsType = "btrfs";
    options = [ "subvol=/" "nofail" "compress=zstd" "noatime" "space_cache=v2" "x-gvfs-show" ];
  };

  fileSystems."/run/media/${username}/500" = {
    device = "/dev/disk/by-uuid/8ad89f3d-6953-4ee7-b6bd-8e1a61e07e87";
    fsType = "btrfs";
    options = [ "nofail" "compress=zstd" "noatime" "space_cache=v2" "x-gvfs-show" ];
  };

  fileSystems."/run/media/${username}/250x1" = {
    device = "/dev/disk/by-uuid/e7b47531-8e65-4096-be54-ca0648b0fe62";
    fsType = "btrfs";
    options = [ "nofail" "compress=zstd" "noatime" "space_cache=v2" "x-gvfs-show" ];
  };

  fileSystems."/run/media/${username}/s128" = {
    device = "/dev/disk/by-uuid/64f25c1b-034c-4f7f-8c38-14ac9eaa83a1";
    fsType = "btrfs";
    options = [ "nofail" "compress=zstd" "noatime" "space_cache=v2" "x-gvfs-show" ];
  };

  fileSystems."/run/media/${username}/x2000" = {
    device = "/dev/disk/by-uuid/e2873f44-a0b2-4c05-9e8a-d14e9cade796";
    fsType = "btrfs";
    options = [ "subvol=/" "nofail" "compress=zstd" "noatime" "space_cache=v2" "x-gvfs-show" ];
 };

  # --- NFS Mounting ---

  fileSystems."/mnt/servers/1000xlab" = {
    device = "192.168.1.100:/mnt/1000xlab";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  swapDevices = [ ];

  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
