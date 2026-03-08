{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  
  homeName = "Syncthing (Home)";
  homeDomain = "syncthing.localhost";
  homePort = 8384;

  labName = "Syncthing (Lab)";
  labDomain = "syncthing-lab.localhost";
  labIp = "192.168.1.100";
  labPort = 8384;
in
{
  networking.hosts."127.0.0.1" = [ homeDomain labDomain ];

  services.nginx.virtualHosts = {
    "${homeDomain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString homePort}";
        proxyWebsockets = true;
      };
    };

    "${labDomain}" = {
      locations."/" = {
        proxyPass = "http://${labIp}:${toString labPort}";
        proxyWebsockets = true;
      };
    };
  };

  home-manager.users.${username} = {
    services.syncthing = {
      enable = true;
      extraOptions = [
        "--gui-address=127.0.0.1:${toString homePort}"
        "--no-browser"
      ];
    };

    xdg.desktopEntries = {
      "${homeName}" = {
        name = homeName;
        icon = "syncthing";
        genericName = "File Synchronization (Local)";
        exec = "${wrapper}/bin/chromium-browser --app=http://${homeDomain}";
        terminal = false;
        categories = [ "Network" "Utility" ];
      };

      "${labName}" = {
        name = labName;
        icon = "syncthing";
        genericName = "File Synchronization (Lab)";
        exec = "${wrapper}/bin/chromium-browser --app=http://${labDomain}";
        terminal = false;
        categories = [ "Network" "Utility" ];
      };
    };
  };
}
