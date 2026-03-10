{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    
    environmentFile = "/etc/duckdns.env";

    virtualHosts = {
      "{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
      
      "torrents.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          reverse_proxy localhost:8080
        '';
      };

      "sync.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          reverse_proxy localhost:8384
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
