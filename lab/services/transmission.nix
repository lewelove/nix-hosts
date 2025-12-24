{ config, pkgs, ... }:

{
  # 1. Enable Transmission Daemon
  services.transmission = {
    enable = true;
    group = "jellyfin"; # Share group with Jellyfin for folder access
    settings = {
      download-dir = "/mnt/drives/hdd1000/media/torrents";
      incomplete-dir = "/mnt/drives/hdd1000/media/torrents/.incomplete";
      incomplete-dir-enabled = true;
      
      # Web UI Settings
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = true;
      # Allow access from local network and Tailscale
      rpc-whitelist = "127.0.0.1,192.168.*.*,100.*.*.*";
      rpc-host-whitelist-enabled = false;
      
      # Peer Settings
      peer-port = 51413;
    };
  };

  # 2. VPN Bypass Routing Logic
  systemd.services.transmission-bypass = {
    description = "Routing rules to bypass VPN for Transmission user";
    after = [ "network.target" "awg-vpn.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Create routing table 100 that points to your ISP router
      ${pkgs.iproute2}/bin/ip route add default via 192.168.1.1 dev enp2s0 table 100 || true
      
      # Tell the kernel: if a packet has mark 1, use table 100
      ${pkgs.iproute2}/bin/ip rule add fwmark 1 lookup 100 priority 1000 || true

      # Use iptables to 'mark' all traffic from the 'transmission' user
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -m owner --uid-owner transmission -j MARK --set-mark 1
      
      # Ensure the source IP is corrected for the ISP interface (SNAT/Masquerade)
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o enp2s0 -m mark --mark 1 -j MASQUERADE
    '';

    postStop = ''
      ${pkgs.iproute2}/bin/ip rule del fwmark 1 lookup 100 || true
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -m owner --uid-owner transmission -j MARK --set-mark 1 || true
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o enp2s0 -m mark --mark 1 -j MASQUERADE || true
    '';
  };

  # 3. Open Firewall Ports
  networking.firewall.allowedTCPPorts = [ 9091 51413 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
