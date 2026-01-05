{ pkgs, lib, username, ... }:

let

  flags = import ../programs/chromium-flags.nix { inherit pkgs lib; };

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
        ExecStart = "${pkgs.ungoogled-chromium}/bin/chromium ${builtins.concatStringsSep " " flags.commonArgs} --silent-launch";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "XDG_CURRENT_DESKTOP=Hyprland"
        ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

}
