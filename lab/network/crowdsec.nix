{ pkgs, ... }:

{
  # 1. The main CrowdSec Engine
  services.crowdsec = {
    enable = true;
    
    # In the new module, if 'acquisitions' still throws an error, 
    # it is because they must be defined in the 'settings' or via a specific file.
    # However, 'acquisitions' SHOULD work in the latest unstable. 
    # If it fails, move the list into 'settings.acquisition_path' or check syntax.
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

  # 2. The Firewall Bouncer (Moved to its own top-level service)
  services.crowdsec-firewall-bouncer = {
    enable = true;
    # On a local machine, it usually auto-configures to talk to the local LAPI.
    # If it fails to start, you may need to define:
    # settings.api_key = "<key>"; 
    # settings.api_url = "http://127.0.0.1:8080/";
  };
}
