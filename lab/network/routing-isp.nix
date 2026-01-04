{ pkgs, ... }:

{

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;
    "net.ipv4.conf.enp2s0.rp_filter" = 2; # Matches your Lab interface
  };

  systemd.services.routing-isp = {
    description = "Routing Policy: Force qBittorrent via ISP Gateway";
    after = [ "network.target" "awg-vpn.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.iproute2}/bin/ip route add default via 192.168.1.1 dev enp2s0 table 101 || true
      
      ${pkgs.iproute2}/bin/ip rule add fwmark 1 lookup 101 priority 1000 || true

      # Enable users for ISP routing
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -m owner --uid-owner qbittorrent -j MARK --set-mark 1
      
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o enp2s0 -m mark --mark 1 -j MASQUERADE
    '';

    postStop = ''
      # Disable users for ISP routing
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -m owner --uid-owner qbittorrent -j MARK --set-mark 1 || true

      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o enp2s0 -m mark --mark 1 -j MASQUERADE || true

      ${pkgs.iproute2}/bin/ip rule del fwmark 1 lookup 101 || true

      ${pkgs.iproute2}/bin/ip route flush table 101 || true
    '';
  };

}
