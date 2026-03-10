{ pkgs, ... }:

{
  systemd.services.won = {
    description = "Wake-on-LAN signal to Home Machine";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.wakeonlan}/bin/wakeonlan -i 192.168.1.255 e0:d5:5e:79:c2:d4";
    };
  };

  systemd.timers.won = {
    description = "Timer to trigger Wake-on-LAN daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 09:00:00";
      
      Persistent = true; 
      
      Unit = "won.service";
    };
  };
}
