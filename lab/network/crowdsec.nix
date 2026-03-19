{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Acquisitions stay under localConfig
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

    # 2. Settings: Use 'lapi' instead of 'api.server'
    settings = {
      lapi = {
        # 'server' is no longer a sub-key; the options are direct
        enable = true;
        listen_uri = "127.0.0.1:8080";
      };
    };
  };

  # 3. Ensure the bouncer points to the same LAPI address
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
    };
  };

  # 4. Permissions for journal access
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}
