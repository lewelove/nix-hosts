{ pkgs, ... }:

{
  systemd.services.routing-bot = {
    description = "Routing Policy: Force Telegram Bot via VPN (Table 100)";
    after = [ "network.target" "awg-vpn.service" ];
    bindsTo = [ "awg-vpn.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -m owner --uid-owner family-office-bot -j MARK --set-mark 2
      ${pkgs.iproute2}/bin/ip rule add fwmark 2 lookup 100 priority 1005 || true
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o active -m mark --mark 2 -j MASQUERADE
    '';

    postStop = ''
      ${pkgs.iproute2}/bin/ip rule del fwmark 2 lookup 100 || true
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -m owner --uid-owner family-office-bot -j MARK --set-mark 2 || true
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o active -m mark --mark 2 -j MASQUERADE || true
    '';
  };
}
