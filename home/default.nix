{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware.nix
    ./packages.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    
    users.lewelove = import ./hm/default.nix;
    
    backupFileExtension = "backup"; 
  };

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

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  system.stateVersion = "25.11"; 
}
