{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    systemd.user.services.figma-agent = {
      Unit = {
        Description = "Figma Agent for Linux (Font Helper)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.figma-agent}/bin/figma-agent";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
