{ pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [ 55555 ];

  environment.systemPackages = with pkgs; [ amneziawg-tools amneziawg-go ];

  systemd.services.awg-inbound = {
    description = "AmneziaWG Inbound (Phone Entry)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    path = with pkgs; [ 
      amneziawg-tools amneziawg-go iproute2 iptables procps gnugrep gnused
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      CONF="/etc/amneziawg/awg-phone.conf"
      
      # 1. Kill any existing phone daemon specifically
      pkill -9 -f "amneziawg-go awg-phone" || true
      ip link delete awg-phone || true
      
      # 2. Start daemon
      amneziawg-go awg-phone &
      sleep 2
      
      # 3. Apply Config (Strip Address/DNS/MTU)
      grep -v -E "^(Address|DNS|MTU|Table)" "$CONF" | awg setconf awg-phone /dev/stdin

      # 4. Networking Setup (RELIABLE IP ASSIGNMENT)
      # Try to get IP from conf, if fail, use 10.10.10.1/24
      EXTRACTED_IP=$(grep '^Address' "$CONF" | cut -d'=' -f2 | tr -d ' ' | cut -d',' -f1)
      FINAL_IP=''${EXTRACTED_IP:-10.10.10.1/24}
      
      ip addr add "$FINAL_IP" dev awg-phone || true
      ip link set mtu 1280 dev awg-phone
      ip link set awg-phone up

      # 5. Rules & Routing
      ip rule add from 10.10.10.1 lookup main priority 100 || true
      
      # Clear and re-add iptables to avoid duplicates
      iptables -t mangle -D PREROUTING -i awg-phone -j MARK --set-mark 100 || true
      iptables -t mangle -A PREROUTING -i awg-phone -j MARK --set-mark 100
      
      # Ensure rule 500 exists for the Spain table
      ip rule add fwmark 100 lookup 100 priority 500 || true
      
      # NAT
      iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o enp2s0 -j MASQUERADE || true
      iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o enp2s0 -j MASQUERADE
    '';

    postStop = ''
      ip rule del from 10.10.10.1 lookup main || true
      ip rule del fwmark 100 lookup 100 || true
      iptables -t mangle -D PREROUTING -i awg-phone -j MARK --set-mark 100 || true
      iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o enp2s0 -j MASQUERADE || true
      ip link delete awg-phone || true
      pkill -9 -f "amneziawg-go awg-phone" || true
    '';
  };
}
