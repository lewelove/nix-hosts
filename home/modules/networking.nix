{ config, pkgs, username, hostname, ... }:

{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
    firewall.allowedTCPPorts = [ 80 8080 6600 ];
    firewall.allowedUDPPorts = [ 9 ]; 

    interfaces.enp3s0.wakeOnLan.enable = true;

    extraHosts = ''
      127.0.0.1 vscode.home
      192.168.1.100 qbittorrent.lab
      192.168.1.100 jellyfin.lab
    '';
  };

  systemd.services.wol-enp3s0 = {
    description = "Force Wake-on-LAN for enp3s0";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp3s0 wol g";
      RemainAfterExit = true;
    };
  };

  environment.systemPackages = [ pkgs.ethtool ];
}
