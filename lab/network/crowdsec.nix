{ pkgs, config, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Acquisitions (journal monitors)
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

    # 2. Settings: General for server, LAPI/CAPI for credentials
    settings = {
      general.api.server = {
        enable = true;
        listen_uri = "127.0.0.1:8080";
      };
      lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
      capi.credentialsFile = "/var/lib/crowdsec/online_api_credentials.yaml";
    };
  };

  # 3. FIX: Symlink the generated NixOS config to the location cscli expects
  # This resolves "Error: open /etc/crowdsec/config.yaml: no such file or directory"
  environment.etc."crowdsec/config.yaml".source = config.services.crowdsec.settingsFile;

  # 4. Firewall Bouncer
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:8080/";
    };
  };

  # 5. Stabilize user/group to prevent DynamicUser migration errors
  users.users.crowdsec = {
    isSystemUser = true;
    group = "crowdsec";
    extraGroups = [ "systemd-journal" ];
  };
  users.groups.crowdsec = {};

  # 6. Ensure the directory is ready
  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
  ];
}
