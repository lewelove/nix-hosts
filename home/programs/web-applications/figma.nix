{ pkgs, lib, username, config, ... }:

let
  flags = config.my.chromium.flags;

  url = "https://figma.com";
  name = "Figma";
  icon = "figma";
  
  # Standard Windows User Agent
  windowUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

  # We manually construct the argument string using escaped double quotes.
  # This is the only quoting style the .desktop validator accepts for spaces.
  userAgentFlag = "--user-agent=\"${windowUserAgent}\"";
  
  # Combine everything into a single string for the Exec key
  execCommand = builtins.concatStringsSep " " [
    "${pkgs.ungoogled-chromium}/bin/chromium"
    (builtins.concatStringsSep " " flags)
    userAgentFlag
    "--app=${url}"
  ];

in

{
  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name;
      genericName = "Graphic Design Tool";
      exec = execCommand;
      terminal = false;
      icon = "${icon}";
      # Only use standard XDG categories to pass validation
      categories = [ "Graphics" ];
    };
  };
}
