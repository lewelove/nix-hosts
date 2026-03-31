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

  systemd.services.lab-bot = {
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
}
