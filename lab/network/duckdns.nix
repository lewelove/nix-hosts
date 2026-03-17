{ pkgs, ... }:

{
  systemd.services.duckdns-update = {
    description = "Update DuckDNS Dynamic IP";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/etc/duckdns.env";
      ExecStart = "${pkgs.curl}/bin/curl -s \"https://www.duckdns.org/update?domains=\${DUCKDNS_DOMAIN}&token=\${DUCKDNS_TOKEN}&ip=\"";
    };

    startAt = "*:0/5"; 
  };
}
