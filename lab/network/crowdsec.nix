{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;
    allowStreamMode = true;
    
    acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
        labels.type = "syslog";
      }
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=caddy.service" ];
        labels.type = "caddy";
      }
    ];
  };

  services.crowdsec.bouncer.firewall = {
    enable = true;
  };
}
