{ config, pkgs, ... }:

{

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.lewelove.extraGroups = [ "jellyfin" ];

}
