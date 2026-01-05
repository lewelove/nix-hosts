{ pkgs, lib, username, ... }:

let

  flags = import ../chromium-flags.nix { inherit pkgs lib; };

in

{

  home-manager.users.${username} = {
    xdg.desktopEntries.youtube = {
      name = "YouTube";
      genericName = "Video Streaming";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "${builtins.concatStringsSep " " flags.commonArgs}"
        "--app=https://youtube.com"
        "--class=youtube-app"
      ];
      terminal = false;
      icon = "youtube";
      categories = [ "Network" "Video" ];
      settings = {
        StartupWMClass = "youtube-app";
      };
    };
  };

}
