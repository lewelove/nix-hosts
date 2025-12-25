{ config, pkgs, inputs, username, ... }:

{
  
  services.getty.autologinUser = "${username}";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash; 
    autoSubUidGidRange = true;
    initialPassword = "lab";
  };

  security.sudo.wheelNeedsPassword = true;

}
