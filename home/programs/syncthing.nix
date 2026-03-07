{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "Syncthing";
  icon = "syncthing";
  domain = "syncthing.localhost";
  port = 8384;
in
{
  networking.hosts."127.0.0.1" = [ domain ];

  services.nginx.virtualHosts."${domain}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  services.syncthing = {
    enable = true;
    user = "${username}";
    group = "users";
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "127.0.0.1:${toString port}";
  };

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "File Synchronization";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}";
      terminal = false;
      categories = [ "Network" "Utility" ];
    };
  };
}
