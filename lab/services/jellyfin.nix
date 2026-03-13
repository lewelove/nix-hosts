{ config, pkgs, ... }:

{

  services.jellyfin = {
    enable = true;
    openFirewall = false;
  };

  users.users.jellyfin.extraGroups = [ "torrents" ];

  users.users.lewelove.extraGroups = [ "jellyfin" ];

}
