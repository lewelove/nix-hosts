{ pkgs, lib, username, ... }:

let

  flags = import ../chromium-flags.nix { inherit pkgs lib; };

  url = "http://192.168.1.100:8096";
  name = "Jellyfin";
  icon = "jellyfin";

in

{

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      name = "${name}";
      genericName = "${name}";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "${builtins.concatStringsSep " " flags.commonArgs}"
        "--app=${url}"
      ];
      terminal = false;
      icon = "${icon}";
    };
  };

}
