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
        # Experimental = true;
        Privacy = "off";
        MinSniffInterval = 0;
        JustWorksRepairing = "always";
        FastConnectable = true;
        UserspaceHID = "true";
        SecureConnections = "false";
        # Capability = "NoInputNoOutput";
        # Class = "0x000100";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

}
