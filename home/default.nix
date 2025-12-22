{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware.nix
    ./packages.nix
    ./programs.nix
    ./games.nix
    ./nvidia.nix
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

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        Enable = "Source,Sink,Media,Socket";
        AutoConnect = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  
  # Enable Blueman (GUI manager and system service)
  services.blueman.enable = true;

  system.stateVersion = "25.11"; 
}
