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

    # 2. Configure LAPI to use port 8085 to avoid the Java conflict on 8080
    settings = {
      api.server.listen_uri = "127.0.0.1:8085";
      lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
    };
  };

  # 3. Synchronize the manual config file with the new port
  environment.etc."crowdsec/config.yaml".text = ''
    api:
      client:
        credentials_path: /var/lib/crowdsec/local_api_credentials.yaml
      server:
        listen_uri: 127.0.0.1:8085
  '';

  # 4. Configure the Firewall Bouncer
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8085/";
      # Use the same credentials file the agent generates
      api_key = ""; # Usually populated by the register service
    };
  };

  # 5. FIX PERMISSIONS: Ensure /var/lib/crowdsec is owned by the crowdsec user.
  # This resolves the "Permission denied" errors during activation.
  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/data 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/state 0750 crowdsec crowdsec -"
  ];

  # 6. Essential permissions for journal access
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}
