{ config, pkgs, ... }:

{

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [ "torrents" ];

  users.users.lewelove.extraGroups = [ "jellyfin" ];

}
