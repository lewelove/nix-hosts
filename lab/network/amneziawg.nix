{ pkgs, ... }:

{
  systemd.services.awg-vpn = {
    description = "AmneziaWG Outbound (Spain Room)";
    after = [ "network.target" ];
    
    path = with pkgs; [ 
      amneziawg-tools
      amneziawg-go
      iproute2
      iptables
      procps
      gnugrep
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      CONF="/etc/amneziawg/active.conf"
      VPN_IP=$(grep '^Address' "$CONF" | cut -d'=' -f2 | xargs)

      ip link delete active || true
      amneziawg-go active &
      sleep 2
      
      grep -v -E "^(Address|DNS|MTU|Table)" "$CONF" | awg setconf active /dev/stdin

      if [ -n "$VPN_IP" ]; then
        ip addr add "$VPN_IP" dev active || true
      fi
      ip link set active up

      ip route add default dev active table 100 || true
      iptables -t nat -A POSTROUTING -o active -j MASQUERADE
    '';

    postStop = ''
      iptables -t nat -D POSTROUTING -o active -j MASQUERADE || true
      ip link delete active || true
      pkill -f amneziawg-go || true
    '';
  };
}
