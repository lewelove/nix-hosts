{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit.enable = true;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_RegistryDwords=RM_DirectScanout=0"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = [
    pkgs.nvidia-container-toolkit
  ];

  environment.sessionVariables = {
    NVD_BACKEND = "direct";
    __GL_SHARPEN_VALUE = "0";
    __GL_FSA_MODE = "0";
    __GL_AA_MODE = "0";
  };
}
