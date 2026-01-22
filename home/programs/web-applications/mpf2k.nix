{ pkgs, lib, username, config, ... }:

let

  flags = config.my.chromium.flags;

  url = "http://localhost:5173/";
  name = "MPF2K";
  icon = "mpf2k";

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
