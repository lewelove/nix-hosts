{ pkgs, lib, username, config, ... }:

let

  flags = config.my.chromium.flags;

in

{

  home-manager.users.${username} = {
    systemd.user.services.chromium-service = {
      Unit = {
        Description = "Chromium Background Service";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.ungoogled-chromium}/bin/chromium ${builtins.concatStringsSep " " flags} --silent-launch";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "XDG_CURRENT_DESKTOP=Hyprland"
        ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

}
