{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "qBittorrent";
  icon = "qbittorrent";
  domain = "qbittorrent.lab";
  ip = "192.168.1.100";
  port = 8080;
in
{
  networking.hosts."${ip}" = [ domain ];

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "Torrent Client";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}:${toString port}";
      terminal = false;
    };
  };
}
