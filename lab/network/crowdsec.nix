{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Acquisitions
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

    # 2. Refactored Settings Path
    # The LAPI listen address is nested under general.api.server
    settings = {
      general.api.server = {
        enable = true;
        listen_uri = "127.0.0.1:8085";
      };
      
      # Use a writable location for credentials
      lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
    };
  };

  # 3. Configure the Firewall Bouncer to point to the new port
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8085/";
    };
  };

  # 4. FIX PERMISSIONS: Ensure directories exist and are writable
  # This resolves the "mkdir: permission denied" errors seen in your logs.
  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/data 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/state 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/state/hub 0750 crowdsec crowdsec -"
  ];

  # 5. Essential permissions for journal access
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}
