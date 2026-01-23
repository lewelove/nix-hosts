{ pkgs, lib, username, config, ... }:

let
  flags = config.my.chromium.flags;
  url = "https://figma.com";
  name = "Figma";
in
{
  home-manager.users.${username}.xdg.desktopEntries.${name} = {
    inherit name;
    genericName = "Graphic Design Tool";
    # We join the flags. Since the User Agent flag already contains 
    # internal double-quotes from chromium.nix, this will be valid.
    exec = "${pkgs.ungoogled-chromium}/bin/chromium ${builtins.concatStringsSep " " flags} --app=${url}";
    terminal = false;
    icon = "figma";
    # Categories MUST be standard. "Design" is not standard.
    categories = [ "Graphics" "Network" ];
  };
}
