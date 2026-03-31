{ config, pkgs, username, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  services.syncthing = {
    enable = true;
    user = username;
    configDir = "/home/${username}/.config/syncthing";
    
    guiAddress = "0.0.0.0:8384";

    overrideDevices = false;
    overrideFolders = false;
  };
}
