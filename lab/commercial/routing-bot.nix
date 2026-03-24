{ pkgs, ... }:

{
  systemd.services.routing-bot = {
    description = "Routing Policy: Force Telegram Bot via VPN (Table 100)";
    after = [ "network.target" "awg-vpn.service" ];
    bindsTo = [ "awg-vpn.service" ]; # If VPN stops, this logic is less relevant
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # 1. Traffic from the 'telegram-bot' user is marked with '2'
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -m owner --uid-owner telegram-bot -j MARK --set-mark 2
      
      # 2. Packets marked with '2' must look up Table 100 (the VPN table)
      ${pkgs.iproute2}/bin/ip rule add fwmark 2 lookup 100 priority 1005 || true

      # 3. Ensure Masquerade is active for the VPN interface
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o active -m mark --mark 2 -j MASQUERADE
    '';

    postStop = ''
      ${pkgs.iproute2}/bin/ip rule del fwmark 2 lookup 100 || true
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -m owner --uid-owner telegram-bot -j MARK --set-mark 2 || true
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o active -m mark --mark 2 -j MASQUERADE || true
    '';
  };
}
