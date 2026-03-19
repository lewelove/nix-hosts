{ pkgs, config, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. New location for acquisitions
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

    # 2. Correct nesting for the API server
    settings = {
      general.api.server = {
        enable = true;
        listen_uri = "127.0.0.1:8080";
      };
      # Mandatory: Tell it where to put credentials so it doesn't try the read-only store
      lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
    };
  };

  # 3. THE CRITICAL FIX: 
  # The bouncer-register service fails because 'cscli' looks in /etc/crowdsec/config.yaml.
  # We link the Nix-generated config to that exact path.
  environment.etc."crowdsec/config.yaml".source = config.services.crowdsec.settingsFile;

  # 4. New standalone bouncer service
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
    };
  };

  # 5. Ensure CrowdSec can read the logs
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}
