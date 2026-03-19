{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Use the new acquisition location
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

    # 2. Configure LAPI credentials to be writable
    settings.lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
  };

  # 3. FIX: Manually provide the config file that cscli / bouncer-register needs.
  # This stops the "open /etc/crowdsec/config.yaml: no such file" error.
  environment.etc."crowdsec/config.yaml".text = ''
    api:
      client:
        credentials_path: /var/lib/crowdsec/local_api_credentials.yaml
      server:
        listen_uri: 127.0.0.1:8080
  '';

  # 4. Enable the standalone bouncer
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
    };
  };

  # 5. Essential permissions
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}
