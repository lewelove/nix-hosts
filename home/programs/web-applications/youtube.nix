{ pkgs, lib, username, ... }:

let

  exts = import ../chromium-extensions.nix { inherit pkgs lib; };

in

{

  home-manager.users.${username} = {
    xdg.desktopEntries.youtube = {
      name = "YouTube";
      genericName = "Video Streaming";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "--app=https://youtube.com"
        "--class=youtube-app"
        "--extension-mime-request-handling=always-prompt-for-install"
        "--load-extension=${exts.ublock-origin.drv},${exts.untrap.drv}"
        "--restore-last-session"
        "--no-default-browser-check"
        "--force-dark-mode"
        "--hide-scrollbars"
        "--hide-fullscreen-exit-ui"
      ];
      terminal = false;
      icon = "youtube";
      categories = [ "Network" "Video" ];
    };
  };

}
