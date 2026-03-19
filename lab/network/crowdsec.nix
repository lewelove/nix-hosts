{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Acquisitions are now under 'localConfig'
    localConfig.acquisitions = [
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

    # 2. Settings: Server config goes under 'general', credentials under 'lapi'/'capi'
    settings = {
      general = {
        api.server = {
          enable = true;
          listen_uri = "127.0.0.1:8080";
        };
      };
      
      lapi = {
        # This MUST be a writable path for CrowdSec to generate its local credentials
        credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
      };

      capi = {
        # Writable path for Central API credentials
        credentialsFile = "/var/lib/crowdsec/online_api_credentials.yaml";
      };
    };
  };

  # 3. The Bouncer is now a standalone top-level service
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
      # Note: The 'register' service will attempt to auto-fill the api_key here
    };
  };

  # 4. Mandatory: Create the directory for credentials and databases
  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
  ];

  # 5. Ensure CrowdSec can read the systemd journal
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}
