{ pkgs, lib, username, config, ... }:

let

  flags = config.my.chromium.flags;

  url = "http://192.168.1.100:8080";
  name = "qBittorrent";
  icon = "qbittorrent";

in

{

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      name = "${name}";
      genericName = "${name}";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "${builtins.concatStringsSep " " flags}"
        "--app=${url}"
      ];
      terminal = false;
      icon = "${icon}";
    };
  };

}
