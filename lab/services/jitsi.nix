{ config, pkgs, lib, ... }:

{
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.lewelaboratory.duckdns.org";
    config = {
      enableWelcomePage = true;
      hosts = {
        domain = "jitsi.lewelaboratory.duckdns.org";
        anonymousdomain = "guest.jitsi.lewelaboratory.duckdns.org";
        muc = "conference.jitsi.lewelaboratory.duckdns.org";
      };
    };
  };

  services.prosody = {
    enable = true;
    virtualHosts."jitsi.lewelaboratory.duckdns.org" = {
      enabled = true;
      extraConfig = ''
        authentication = "internal_plain"
      '';
    };
    virtualHosts."guest.jitsi.lewelaboratory.duckdns.org" = {
      enabled = true;
      extraConfig = ''
        authentication = "anonymous"
      '';
    };
  };

  services.nginx.virtualHosts."jitsi.lewelaboratory.duckdns.org" = {
    listen = [ { addr = "127.0.0.1"; port = 8081; } ];
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
