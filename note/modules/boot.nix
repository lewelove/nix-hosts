{ config, pkgs, lib, username, hostname, ... }:

{

  # --- Boot ---
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    devices = lib.mkForce [ "/dev/sda" ];
    version = 2;
    efiSupport = false;
    useOSProber = true;
  };

  zramSwap.enable = true;

}
