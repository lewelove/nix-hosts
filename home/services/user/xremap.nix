{ pkgs, config, ... }:

{
  systemd.user.services.xremap = {
    Unit = {
      Description = "xremap user service";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      # Points to the file managed by your stow script
      ExecStart = "${pkgs.xremap}/bin/xremap ${config.home.homeDirectory}/.config/xremap/config.yml --watch";
      Restart = "always";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
