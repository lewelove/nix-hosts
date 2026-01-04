{ config, pkgs, ... }:

{

  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    openFirewall = true;
    user = "qbittorrent";
    group = "torrents";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/drives/hdd1000 0775 lewelove torrents -"
    "d /mnt/drives/hdd1000/downloads 2775 qbittorrent torrents -"
  ];

  users.groups.torrents = {};

  users.users.lewelove.extraGroups = [ "torrents" ];

}
