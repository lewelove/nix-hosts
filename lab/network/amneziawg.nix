{ pkgs, ... }:

{
  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    path = with pkgs; [ amneziawg-tools amneziawg-go iproute2 iptables openresolv procps ];
    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf";

      ExecStartPost = pkgs.writeShellScript "awg-post-start" ''
        # Simple MSS Clamping for Spain
        ${pkgs.iptables}/bin/iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';

      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf";
    };
  };
}
