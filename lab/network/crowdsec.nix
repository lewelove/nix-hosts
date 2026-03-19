{ pkgs, ... }:

{
  services.crowdsec = {
    enable = true;

    # 1. Acquisitions moved under localConfig
    localConfig.acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
        labels.type = "syslog";
      }
      # Add your other acquisitions here...
    ];

    # 2. (Optional) Declarative Hub management
    # hub.collections = [ "crowdsecurity/linux" "crowdsecurity/sshd" ];
  };

  # 3. Firewall Bouncer is now its own service
  services.crowdsec-firewall-bouncer = {
    enable = true;
    # On Unstable, it usually defaults to nftables. 
    # If you need to specify settings, use:
    # settings.mode = "nftables"; 
  };
}
