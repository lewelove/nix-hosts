{ pkgs, ... }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    python-telegram-bot
  ]);
in
{
  users.users.family-office-bot = {
    isSystemUser = true;
    group = "family-office-bot";
    home = "/var/lib/commercial/family-office-bot";
    createHome = true;
  };
  users.groups.family-office-bot = {};

  systemd.tmpfiles.rules = [
    "d /var/lib/commercial/family-office-bot 0750 family-office-bot family-office-bot -"
  ];

  systemd.services.family-office-bot = {
    description = "Family Office Telegram Bot";
    after = [ "network.target" "awg-vpn.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "family-office-bot";
      Group = "family-office-bot";
      
      WorkingDirectory = "/var/lib/commercial/family-office-bot";
      EnvironmentFile = "/etc/telegram-bot.env";
      
      ExecStart = "${pythonEnv}/bin/python /var/lib/commercial/family-office-bot/bot.py";
      
      Restart = "always";
      RestartSec = "10s";

      ProtectHome = "true";
      ProtectSystem = "full";
      ReadWritePaths = [ "/var/lib/commercial/family-office-bot" ];
    };
  };

  systemd.services.family-office-bot-vpn = {
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
