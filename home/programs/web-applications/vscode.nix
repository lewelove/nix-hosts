{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  url = "http://localhost:4444/"; # Default to dev folder
  name = "VS Code";
  icon = "code";
in
{
  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "Web-based IDE";
      exec = "${wrapper}/bin/chromium-browser --app=${url}";
      terminal = false;
      categories = [ "Development" "TextEditor" ];
    };
  };
}
