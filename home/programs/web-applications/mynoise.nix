{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    xdg.desktopEntries.youtube = {
      name = "MyNoise";
      genericName = "Noise Generator";
      exec = builtins.concatStringsSep " " [
        "${pkgs.ungoogled-chromium}/bin/chromium"
        "--app=https://youtube.com"
        "--class=youtube-app"
        "--no-default-browser-check"
        "--hide-scrollbars"
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
