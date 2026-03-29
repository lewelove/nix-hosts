{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    environmentFile = "/etc/duckdns.env";

    extraConfig = ''
      (logging) {
        log {
          output file /var/log/caddy/access.log
          format json
        }
      }

      (auth) {
        forward_auth localhost:9091 {
          uri /api/verify?rd=https://auth.{$DUCKDNS_DOMAIN}/
          copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
        }
      }

      (drop_scanners) {
        @scanners {
          path *.php *.env *.git* *.xml *.yaml *.yml *.ini *.sql *.bak *.swp *.save *.log
          path_regexp wp ^/wp-
        }
        respond @scanners "Forbidden" 403
      }
    '';

    virtualHosts = {
      "auth.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
          import drop_scanners
          reverse_proxy localhost:9091
        '';
      };

      "jellyfin.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
          import drop_scanners
          import auth
          reverse_proxy localhost:8096
        '';
      };

      "jitsi.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
          import drop_scanners
          reverse_proxy localhost:8082 {
              header_up Host {host}
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}
          }
        '';
      };

      "vellum.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
          import drop_scanners
          import auth
          reverse_proxy 127.0.0.1:5173
        '';
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy -"
    "f /var/log/caddy/access.log 0644 caddy caddy -"
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
