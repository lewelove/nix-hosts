{ config, pkgs, ... }:

{
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.lewelaboratory.duckdns.org";
    config = {
      enableWelcomePage = true;
    };
  };

  services.nginx.virtualHosts."jitsy.lewelaboratory.duckdns.org" = {
    listen = [ { addr = "127.0.0.1"; port = 8081; } ];
    addSSL = false;
    enableACME = false;
  };

  networking.firewall = {
    allowedTCPPorts = [ 4443 ];
    allowedUDPPorts = [ 10000 ];
  };

  services.jitsi-videobridge.openFirewall = true;
}
