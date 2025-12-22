{ pkgs, ... }:

{

  # --- SWWW Wallpaper Daemon ---
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland Wallpaper Daemon";
      PartOf = [ "wayland-session.target" ];
      After = [ "wayland-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
      RestartSec = 1;
      Type = "simple";
    };
    Install = {
      WantedBy = [ "wayland-session.target" ];
    };
  };

}
