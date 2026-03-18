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
      EnvironmentFile = "/home/lewelove/commercial/family-office-bot/.env";
      WorkingDirectory = "/home/lewelove/commercial/family-office-bot";
      ExecStart = "${pythonEnv}/bin/python /home/lewelove/commercial/family-office-bot/bot.py";
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
