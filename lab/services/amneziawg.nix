{ pkgs, ... }:

{
  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    
    path = with pkgs; [ 
      amneziawg-tools
      amneziawg-go
      iproute2
      iptables
      openresolv
      procps
    ];

    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf";

      ExecStartPost = pkgs.writeShellScript "awg-post-start" ''
        # Tailscale stays in Tier 2 (Safe at 500)
        ${pkgs.iproute2}/bin/ip rule add to 100.64.0.0/10 lookup 52 priority 500 || true
        ${pkgs.iptables}/bin/iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';

      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf";
      
      ExecStopPost = pkgs.writeShellScript "awg-post-stop" ''
        ${pkgs.iproute2}/bin/ip rule del priority 500 || true
      '';
    };
  };
}
