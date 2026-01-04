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
    "d /mnt/1000xlab 0775 lewelove torrents -"
    "d /mnt/1000xlab/downloads 2775 qbittorrent torrents -"
  ];

  users.users.qbittorrent.uid = 993;
  users.groups.torrents.gid = 990;

  users.users.lewelove.extraGroups = [ "torrents" ];

}
