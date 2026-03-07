{ config, pkgs, username, ... }:

let
  name = "Syncthing";
  icon = "syncthing";
  domain = "syncthing.lab";
  port = 8384;
in
{
  # networking.firewall.allowedTCPPorts = [ 22000 ];
  # networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  #
  # services.nginx.virtualHosts."${domain}" = {
  #   locations."/" = {
  #     proxyPass = "http://127.0.0.1:${toString port}";
  #     proxyWebsockets = true;
  #   };
  # };

  services.syncthing = {
    enable = true;
    user = "${username}";
    group = "users";
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "127.0.0.1:${toString port}";
    };
  };
}
