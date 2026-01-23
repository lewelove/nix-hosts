{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  url = "http://192.168.1.100:8080";
  name = "qBittorrent";
  icon = "qbittorrent";
in
{
  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "Torrent Client";
      exec = "${wrapper}/bin/chromium-browser --app=${url}";
      terminal = false;
    };
  };
}
