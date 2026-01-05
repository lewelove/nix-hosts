{ pkgs, lib, username, ... }:

let

  flags = import ../chromium-flags.nix { inherit pkgs lib; };

in

{

  home-manager.users.${username} = {
    xdg.desktopEntries.youtube = {
      name = "Figma";
      genericName = "Vector Graphics Editor";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "${builtins.concatStringsSep " " flags.commonArgs}"
        "--app=https://figma.com"
        "--class=figma"
      ];
      terminal = false;
      icon = "figma";
    };
  };

}
