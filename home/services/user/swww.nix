{ pkgs, ... }:

{

  # --- SWWW Wallpaper Daemon ---
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland Wallpaper Daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
      Type = "simple";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
