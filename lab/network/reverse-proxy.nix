{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    environmentFile = "/etc/duckdns.env";

    virtualHosts = {
      "{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          forward_auth localhost:9091 {
            uri /api/verify?rd=https://{$DUCKDNS_DOMAIN}/authelia/
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }

          reverse_proxy localhost:8096
        '';
      };

      "{$DUCKDNS_DOMAIN}/authelia/*" = {
        extraConfig = ''
          reverse_proxy localhost:9091
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
