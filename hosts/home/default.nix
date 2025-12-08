{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "home";

  # Boot
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  zramSwap.enable = true;

  # Hardware
  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  
  system.stateVersion = "25.11"; 
}
