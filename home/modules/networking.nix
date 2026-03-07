{ config, pkgs, username, hostname, ... }:

{
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
    firewall.allowedTCPPorts = [ 80 8080 6600 666 ];
    firewall.allowedUDPPorts = [ 9 ]; 

    interfaces.enp3s0.wakeOnLan.enable = true;

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
