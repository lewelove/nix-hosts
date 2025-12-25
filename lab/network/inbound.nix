{ pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [ 55555 ];

  environment.systemPackages = with pkgs; [ amneziawg-tools amneziawg-go ];

  systemd.services.awg-inbound = {
    description = "AmneziaWG Inbound (Phone Entry)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    path = with pkgs; [ 
      amneziawg-tools amneziawg-go iproute2 iptables procps gnugrep
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      CONF="/etc/amneziawg/awg-phone.conf"
      VPN_IP=$(grep '^Address' "$CONF" | cut -d'=' -f2 | xargs || true)

      # 1. Targeted cleanup: only kill the phone daemon if it's already running
      pkill -f "amneziawg-go awg-phone" || true
      ip link delete awg-phone || true
      
      amneziawg-go awg-phone &
      sleep 2
      
      grep -v -E "^(Address|DNS|MTU|Table)" "$CONF" | awg setconf awg-phone /dev/stdin

      if [ -n "$VPN_IP" ]; then
        ip addr add "$VPN_IP" dev awg-phone || true
      fi
      
      # 2. Lower MTU to 1280 (Standard for nested/mobile tunnels)
      ip link set mtu 1280 dev awg-phone
      ip link set awg-phone up

      # 3. Routing & Rules
      ip rule add from 10.10.10.1 lookup main priority 100 || true
      iptables -t mangle -A PREROUTING -i awg-phone -j MARK --set-mark 100
      
      # Bypass VPN table for Local LAN (192.168.1.0/24)
      ip rule add fwmark 100 to 192.168.1.0/24 lookup main priority 400 || true
      # Follow VPN Table 100
      ip rule add fwmark 100 lookup 100 priority 500 || true
      
      # 4. NAT and MTU Clamping (Crucial for stacked Amnezia)
      iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o enp2s0 -j MASQUERADE
      iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    '';

    postStop = ''
      ip rule del from 10.10.10.1 lookup main || true
      ip rule del fwmark 100 lookup 100 || true
      ip rule del fwmark 100 to 192.168.1.0/24 lookup main || true
      iptables -t mangle -D PREROUTING -i awg-phone -j MARK --set-mark 100 || true
      iptables -t mangle -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu || true
      ip link delete awg-phone || true
      pkill -f "amneziawg-go awg-phone" || true
    '';
  };
}
