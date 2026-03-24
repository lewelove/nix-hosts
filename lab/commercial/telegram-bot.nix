{ pkgs, ... }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    python-telegram-bot
  ]);
in
{
  users.users.telegram-bot = {
    isSystemUser = true;
    group = "telegram-bot";
  };
  users.groups.telegram-bot = {};

  systemd.services.lab-bot = {
    description = "Family Office Telegram Bot";
    after = [ "network.target" "awg-vpn.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "telegram-bot";
      Group = "telegram-bot";
      WorkingDirectory = "/home/lewelove/commercial/family-office-bot";
      EnvironmentFile = "/etc/telegram-bot.env";
      ExecStart = "${pythonEnv}/bin/python /home/lewelove/commercial/family-office-bot/bot.py";
      
      ProtectHome = false;
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
