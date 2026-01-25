{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  url = "http://localhost:5173/";
  name = "Eluxum";
  icon = "eluxum";
in
{
  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      exec = "${wrapper}/bin/chromium-browser --app=${url}";
      terminal = false;
    };
  };
}
