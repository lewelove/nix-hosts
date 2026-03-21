{ config, pkgs, lib, ... }:

{
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.lewelaboratory.duckdns.org";
    config = {
      enableWelcomePage = true;
    };
  };

  services.nginx.virtualHosts."jitsi.lewelaboratory.duckdns.org" = {
    listen = [ { addr = "127.0.0.1"; port = 8082; } ];
    addSSL = lib.mkForce false;
    forceSSL = lib.mkForce false;
    enableACME = lib.mkForce false;
    onlySSL = lib.mkForce false;
  };

  networking.firewall = {
    allowedTCPPorts = [ 4443 ];
    allowedUDPPorts = [ 10000 ];
  };

  services.jitsi-videobridge.openFirewall = true;
}
