{ config, pkgs, ... }:

{
  services.jitsi-meet = {
    enable = true;
    # Replace with your actual DuckDNS domain
    hostName = "meet.lewelaboratory.duckdns.org";
    config = {
      # Allow guests to join without an account
      enableWelcomePage = true;
    };
  };

  # Jitsi's NixOS module strictly requires Nginx. 
  # We'll make Nginx listen on a local port so Caddy can proxy to it.
  services.nginx.virtualHosts."jitsy.lewelaboratory.duckdns.org" = {
    listen = [ { addr = "127.0.0.1"; port = 8081; } ];
    addSSL = false;
    enableACME = false;
  };

  # Open the video stream ports (UDP 10000 is critical)
  networking.firewall = {
    allowedTCPPorts = [ 4443 ]; # Fallback for media
    allowedUDPPorts = [ 10000 ]; # RTP Media stream (Videobridge)
  };

  services.jitsi-videobridge.openFirewall = true;
}
