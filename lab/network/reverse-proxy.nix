{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    environmentFile = "/etc/duckdns.env";

    # Define a snippet for logging to avoid global block conflicts
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
    '';

    virtualHosts = {
      "auth.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
          reverse_proxy localhost:9091
        '';
      };

      "jellyfin.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
          import auth
          reverse_proxy localhost:8096
        '';
      };

      "jitsi.{$DUCKDNS_DOMAIN}" = {
        extraConfig = ''
          import logging
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
          import auth
          reverse_proxy 127.0.0.1:5173
        '';
      };
    };
  };

  # Ensure the log directory exists and Caddy can write to it
  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy -"
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
