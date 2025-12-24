{ pkgs, ... }:

{
  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    
    path = with pkgs; [ 
      amneziawg-tools amneziawg-go iproute2 iptables openresolv procps
    ];

    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      
      # THE "NORMAL" SOLUTION: 
      # We tell Spain to put routes in table 51820. 
      # This stops 'awg-quick' from creating its own aggressive rules.
      ExecStart = pkgs.writeShellScript "awg-up-manual" ''
        export WG_QUICK_USERSPACE_IMPLEMENTATION=amneziawg-go
        # We manually run 'awg-quick' but override the Table behavior
        ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf
        
        # Now we add the policy rule AT A FIXED PRIORITY (2000)
        # This rule says: "Use Spain for everything, UNLESS a higher priority rule matched first"
        # Since your Phone is at 100, the Phone always wins for Handshakes/Local.
        ${pkgs.iproute2}/bin/ip rule add not from all fwmark 51820 lookup 51820 priority 2000 || true
        ${pkgs.iptables}/bin/iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';

      ExecStop = pkgs.writeShellScript "awg-down-manual" ''
        ${pkgs.iproute2}/bin/ip rule del priority 2000 || true
        ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf
      '';
    };
  };
}
