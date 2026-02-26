{ config, pkgs, username, hostname, ... }:

{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    
    interfaces.enp3s0.wakeOnLan.enable = true; 

    firewall.checkReversePath = "loose";
    firewall.allowedTCPPorts = [ 80 8080 6600 ];
    firewall.allowedUDPPorts = [ 9 ];

    extraHosts = ''
      127.0.0.1 vscode.home
      192.168.1.100 qbittorrent.lab
      192.168.1.100 jellyfin.lab
    '';
  };

  environment.systemPackages = [ 
    pkgs.ethtool 
  ];
}
