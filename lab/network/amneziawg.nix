{ pkgs, ... }:

{
  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    path = with pkgs; [ amneziawg-tools amneziawg-go iproute2 iptables coreutils ];
    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      
      ExecStart = pkgs.writeShellScript "awg-up-isolated" ''
        # Force Table=off behavior by preventing awg-quick from seeing a 'Table' setting
        # This ensures awg-quick ONLY sets up the interface and routes in a custom table
        ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf

        # THE RIGOROUS FIX:
        # 1. Ensure the Spain VPN has a default route in its own table
        # (awg-quick should have done this, but we force it)
        ip route add default dev active table 51820 || true

        # 2. FORWARD PHONE TO SPAIN: 
        # Any traffic originating from the phone's network MUST use the Spain Table.
        # This priority (1000) is after your 'main' bypasses (10-11).
        ip rule add from 10.10.10.0/24 lookup 51820 priority 1000 || true

        # 3. OPTIONAL: Force Lab internet to Spain (Comment this if you want Lab in Russia)
        ip rule add not from all fwmark 51820 lookup 51820 priority 1001 || true

        # 4. MSS Clamping
        iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';

      ExecStop = pkgs.writeShellScript "awg-down-isolated" ''
        ip rule del priority 1000 || true
        ip rule del priority 1001 || true
        ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf
      '';
    };
  };
}
