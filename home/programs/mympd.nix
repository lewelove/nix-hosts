{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "myMPD";
  icon = "mympd";
  domain = "mpd.localhost";
  port = 666;
in
{
  networking.hosts."127.0.0.1" = [ domain ];

  services.mympd = {
    enable = true;
    settings.http_port = port;
  };

  services.nginx.virtualHosts."${domain}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "MPD Web Client";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}";
      terminal = false;
    };
  };
}
