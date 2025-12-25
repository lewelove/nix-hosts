{ config, pkgs, inputs, username, ... }:

{
  
  services.getty.autologinUser = "${username}";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash; 
    autoSubUidGidRange = true;
    initialPassword = "lab";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINngwDtUZAiEALEZ1XhPXX221hYqjGSaqWRnvaUnpMXT lewelove@proton.me"
    ];
  };

  security.sudo.wheelNeedsPassword = true;

}
