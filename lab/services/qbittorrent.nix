{ config, pkgs, ... }:

{

  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    openFirewall = true;
    user = "qbittorrent";
    group = "torrents";
  };

  users.groups.torrents = {};

  users.users.lewelove.extraGroups = [ "torrents" ];

}
