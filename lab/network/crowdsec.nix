{ pkgs, config, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Ensure the Local API (LAPI) is explicitly enabled
    settings = {
      api.server = {
        enable = true;
        listen_uri = "127.0.0.1:8080";
      };
      # Optional: explicitly set DB type if it fails to initialize
      db_config = {
        type = "sqlite";
      };
    };

    # 2. Re-verify acquisitions are under localConfig
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
  };

  # 3. CrowdSec needs to read the journal
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];

  # 4. Correct the Bouncer configuration
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
      # The registration service will attempt to fill in the api_key automatically.
      # If it continues to fail, you may need to provide a key file manually.
    };
  };

  # 5. Fix for potential permission issues in /var/lib/crowdsec
  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
  ];
}
