{ config, pkgs, inputs, ... }:

{
  
  # --- Bluetooth ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        AutoConnect = true;
        Privacy = "off";
        JustWorksRepairing = "always";
        FastConnectable = true;
        ControllerMode = "bredr";
        UserspaceHID = "false";
      };
      Input = {
        ClassicBondedOnly = false;
      };
      Policy = {
        AutoEnable = true;
        ReconnectAttempts = 7;
        ReconnectInterval = 2;
      };
    };
  };

  services.blueman.enable = true;

  services.udev.extraRules = ''
    # Nintendo Pro Controller (Bluetooth)
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0660", TAG+="uaccess"
    
    # Xbox One S / Series X Controller (Bluetooth)
    KERNEL=="hidraw*", KERNELS=="*045E:02FD*", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*045E:0B13*", MODE="0660", TAG+="uaccess"
  '';

}
