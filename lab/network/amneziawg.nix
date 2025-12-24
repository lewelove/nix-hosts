{ pkgs, ... }:

{
  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    path = with pkgs; [ amneziawg-tools amneziawg-go iproute2 iptables gnugrep coreutils ];
    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "awg-isolated-up" ''
        # 1. Start the VPN normally
        ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf

        # 2. THE ANCHOR: Locate and Demote awg-quick's aggressive rules
        # Identify the table ID used by awg-quick (usually 51820)
        TABLE_ID=51820
        
        # Move the 'suppress_prefixlength' rule to Tier 3
        ${pkgs.iproute2}/bin/ip rule add lookup main suppress_prefixlength 0 priority 1999 || true
        # Move the default gateway rule to Tier 3
        ${pkgs.iproute2}/bin/ip rule add not from all fwmark 51820 lookup $TABLE_ID priority 2000 || true

        # Delete the aggressive rules awg-quick created (usually priority < 100)
        # We find them by searching for the table ID and prefix suppression
        ${pkgs.iproute2}/bin/ip rule show | grep "suppress_prefixlength 0" | grep -v "1999:" | head -n 1 | cut -d ":" -f 1 | xargs -I {} ${pkgs.iproute2}/bin/ip rule del priority {} || true
        ${pkgs.iproute2}/bin/ip rule show | grep "lookup $TABLE_ID" | grep -v "2000:" | head -n 1 | cut -d ":" -f 1 | xargs -I {} ${pkgs.iproute2}/bin/ip rule del priority {} || true

        # Tier 2 Bypass: Tailscale
        ${pkgs.iproute2}/bin/ip rule add to 100.64.0.0/10 lookup 52 priority 500 || true
        ${pkgs.iptables}/bin/iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';

      ExecStop = pkgs.writeShellScript "awg-isolated-down" ''
        ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf || true
        ${pkgs.iproute2}/bin/ip rule del priority 1999 || true
        ${pkgs.iproute2}/bin/ip rule del priority 2000 || true
        ${pkgs.iproute2}/bin/ip rule del priority 500 || true
      '';
    };
  };
}
