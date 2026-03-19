{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Acquisitions move here
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

    # 2. Modern structured settings
    settings = {
      # Use lapi.server to enable the Local API engine
      lapi = {
        server = {
          enable = true;
          listen_uri = "127.0.0.1:8080";
        };
        # MUST point to a writable path for auto-generated credentials
        credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
      };
      
      capi = {
        # Optional: path for online API credentials
        credentialsFile = "/var/lib/crowdsec/online_api_credentials.yaml";
      };
    };
  };

  # 3. Firewall Bouncer is now its own standalone service
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
      # On first run, this service will attempt to auto-register with the LAPI.
      # If it fails, check 'systemctl status crowdsec-firewall-bouncer-register'
    };
  };

  # 4. Ensure permissions for log reading
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];

  # 5. Ensure the state directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
  ];
}
