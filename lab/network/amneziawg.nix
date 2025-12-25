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
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      amneziawg-go active &
      sleep 2
      
      awg setconf active /etc/amneziawg/active.conf
      ip addr add 10.8.0.2/24 dev active || true
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
