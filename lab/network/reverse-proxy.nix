{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    
    environmentFile = "/etc/duckdns.env";

    virtualHosts = {
      "jellyfin.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          basicauth * {
            lewelove $2a$14$QCg4lYo7UFzsX7HwZYIdn.D/F05QFh4lp121dcpRhRFdDb14TP3Ju
          }
          reverse_proxy localhost:8096 {
            header_up Host {host}
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}
          }
        '';
      };
      
      # "torrents.{$DUCKDNS_DOMAIN}" = {
      #   extraConfig = ''
      #     reverse_proxy localhost:8080
      #   '';
      # };
      #
      # "sync.{$DUCKDNS_DOMAIN}" = {
      #   extraConfig = ''
      #     reverse_proxy localhost:8384
      #   '';
      # };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
