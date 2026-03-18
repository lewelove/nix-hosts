{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    environmentFile = "/etc/duckdns.env";

    extraConfig = ''
      (auth) {
        forward_auth localhost:9091 {
          uri /api/verify?rd=https://auth.{$DUCKDNS_DOMAIN}/
          copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
        }
      }
    '';

    virtualHosts = {
      "auth.{$DUCKDNS_DOMAIN}" = {
        extraConfig = "reverse_proxy localhost:9091";
      };

      "jellyfin.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import auth
          reverse_proxy localhost:8096
        '';
      };

      "jitsi.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          reverse_proxy localhost:8082
        '';
      };

      "vellum.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import auth
          reverse_proxy 127.0.0.1:5173
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
