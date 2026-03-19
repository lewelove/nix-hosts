{ pkgs, lib, ... }:

{
  # 1. Enable the basic services but we will override their "broken" defaults
  services.crowdsec.enable = true;
  services.crowdsec-firewall-bouncer.enable = true;

  # 2. Provide the "Standard" YAML files directly to /etc/crowdsec
  environment.etc = {
    "crowdsec/config.yaml".text = ''
      common:
        daemonize: false
        log_level: info
        log_media: file
        log_dir: /var/log/
        working_dir: /var/lib/crowdsec/
      config_paths:
        config_dir: /etc/crowdsec/
        data_dir: /var/lib/crowdsec/data/
        hub_dir: /var/lib/crowdsec/hub/
        index_path: /var/lib/crowdsec/hub/.index.json
        notification_dir: /etc/crowdsec/notifications/
        plugin_dir: /var/lib/crowdsec/plugins/
      api:
        client:
          insecure_skip_verify: false
          credentials_path: /var/lib/crowdsec/local_api_credentials.yaml
        server:
          log_level: info
          listen_uri: 127.0.0.1:8080
          profiles_path: /etc/crowdsec/profiles.yaml
          online_client:
            credentials_path: /var/lib/crowdsec/online_api_credentials.yaml
      db_config:
        type: sqlite
        db_path: /var/lib/crowdsec/data/crowdsec.db
    '';

    "crowdsec/acquisitions.yaml".text = ''
      source: journalctl
      journalctl_filter:
        - _SYSTEMD_UNIT=sshd.service
      labels:
        type: syslog
      ---
      source: journalctl
      journalctl_filter:
        - _TRANSPORT=journal
      labels:
        type: syslog
    '';

    "crowdsec/profiles.yaml".text = ''
      name: default_ip_remediation
      filters:
       - Alert.Remediation == true && Alert.GetScope() == "Ip"
      decisions:
       - type: ban
         duration: 4h
      on_success: break
    '';
  };

  # 3. FIX: Override the systemd units to use our /etc/ files instead of store paths
  systemd.services.crowdsec.serviceConfig = {
    ExecStart = lib.mkForce "${pkgs.crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml -acq /etc/crowdsec/acquisitions.yaml";
    # Prevent the DynamicUser mess from shifting your /var/lib permissions
    DynamicUser = lib.mkForce false;
  };

  # 4. FIX: Fix the Bouncer registration service
  systemd.services.crowdsec-firewall-bouncer-register.serviceConfig = {
    # Ensure it sees the config file so it doesn't fail with "no such file"
    BindPaths = [ "/etc/crowdsec" ];
    DynamicUser = lib.mkForce false;
  };

  # 5. Stabilize user and permissions
  users.users.crowdsec = {
    isSystemUser = true;
    group = "crowdsec";
    extraGroups = [ "systemd-journal" ];
  };
  users.groups.crowdsec = {};

  systemd.tmpfiles.rules = [
    "d /var/lib/crowdsec 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/data 0750 crowdsec crowdsec -"
    "d /var/lib/crowdsec/hub 0750 crowdsec crowdsec -"
  ];

  # 6. Point the bouncer to the API
  services.crowdsec-firewall-bouncer.settings = {
    api_url = "http://127.0.0.1:8080/";
  };
}
