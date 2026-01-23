{ pkgs, lib, username, config, ... }:

let

  flags = config.my.chromium.flags;

  url = "https://figma.com";
  name = "Figma";
  icon = "figma";

  windowUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

in

{

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      name = "${name}";
      genericName = "${name}";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "${builtins.concatStringsSep " " flags}"
        "--user-agent=\"${windowUserAgent}\""
        "--app=${url}"
      ];
      terminal = false;
      icon = "${icon}";
    };
  };

}
