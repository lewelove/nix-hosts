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
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf";

      ExecStartPost = pkgs.writeShellScript "awg-post-start" ''
        # --- THE BYPASS RULES ---
        # We find the current priority of the Spain VPN and put ourselves 1 step ahead.
        # This is the "Professional" way to handle dynamic wg-quick priorities.
        
        # 1. Protection for Phone Subnet
        ${pkgs.iproute2}/bin/ip rule add to 10.10.10.0/24 lookup main priority 100 || true
        # 2. Protection for Local LAN (Jellyfin/SSH)
        ${pkgs.iproute2}/bin/ip rule add to 192.168.1.0/24 lookup main priority 101 || true
        # 3. Protection for Tailscale
        ${pkgs.iproute2}/bin/ip rule add to 100.64.0.0/10 lookup 52 priority 102 || true

        # Clamp MSS for outgoing VPN traffic
        ${pkgs.iptables}/bin/iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';

      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf";
      
      ExecStopPost = pkgs.writeShellScript "awg-post-stop" ''
        # Cleanup protection rules
        ${pkgs.iproute2}/bin/ip rule del priority 100 || true
        ${pkgs.iproute2}/bin/ip rule del priority 101 || true
        ${pkgs.iproute2}/bin/ip rule del priority 102 || true
      '';
    };
  };
}
