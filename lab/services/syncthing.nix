{ config, pkgs, username, ... }:

let
  name = "Syncthing";
  icon = "syncthing";
  domain = "syncthing.lab";
  port = 8384;
in
{
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  # services.nginx.virtualHosts."${domain}" = {
  #   locations."/" = {
  #     proxyPass = "http://127.0.0.1:${toString port}";
  #     proxyWebsockets = true;
  #   };
  # };

  home-manager.users.${username} = {
    services.syncthing = {
      enable = true;
      extraOptions = [
        "--gui-address=0.0.0.0:8384"
      ];
    };
  };
}
