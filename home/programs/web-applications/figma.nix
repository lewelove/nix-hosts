{ pkgs, lib, username, ... }:

let

  flags = import ../chromium-flags.nix { inherit pkgs lib; };

  url = "https://figma.com";
  name = "Figma";
  icon = "figma";

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
