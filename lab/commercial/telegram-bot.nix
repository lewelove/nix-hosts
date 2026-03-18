{ pkgs, ... }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    python-telegram-bot
  ]);
in
{
  systemd.services.lab-bot = {
    description = "Family Office Telegram Bot";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "lewelove";
      Group = "users";
      WorkingDirectory = "/home/lewelove/commercial/family-office-bot";
      EnvironmentFile = "/etc/telegram-bot.env";
      ExecStart = "${pythonEnv}/bin/python /home/lewelove/commercial/family-office-bot/bot.py";
      
      ProtectHome = false;
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
