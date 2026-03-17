{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 9091 54321 ];

  systemd.tmpfiles.rules = [
    "d /mnt/drives/hdd1000 0775 lewelove jellyfin -"
    "d /mnt/drives/hdd1000/media 2775 lewelove jellyfin -"
    "d /mnt/drives/hdd1000/media/torrents 2775 transmission jellyfin -"
    "d /mnt/drives/hdd1000/media/torrents/.incomplete 2775 transmission jellyfin -"
  ];

  services.transmission = {
    enable = true;
    group = "jellyfin"; 
    settings = {
      umask = 2;
      download-dir = "/mnt/drives/hdd1000/media/torrents";
      incomplete-dir-enabled = false;
      cache-size-mb = 1024;
      peer-limit-global = 2000;
      peer-limit-per-torrent = 500;
      encryption = 1;
      peer-port = 54321;
      port-forwarding-enabled = false;
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = true;
      rpc-whitelist = "127.0.0.1,192.168.*.*,100.*.*.*,10.*.*.*";
      rpc-host-whitelist-enabled = false;
    };
  };

  systemd.services.transmission-bypass = {
    description = "Routing rules to bypass VPN for Transmission user (using Table 101)";
    after = [ "network.target" "awg-vpn.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.iproute2}/bin/ip route add default via 192.168.1.1 dev enp2s0 table 101 || true
      ${pkgs.iproute2}/bin/ip rule add fwmark 1 lookup 101 priority 1000 || true
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -m owner --uid-owner transmission -j MARK --set-mark 1
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o enp2s0 -m mark --mark 1 -j MASQUERADE
    '';

    postStop = ''
      ${pkgs.iproute2}/bin/ip rule del fwmark 1 lookup 101 || true
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -m owner --uid-owner transmission -j MARK --set-mark 1 || true
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o enp2s0 -m mark --mark 1 -j MASQUERADE || true
      ${pkgs.iproute2}/bin/ip route flush table 101 || true
    '';
  };
}
