{ pkgs, ... }:

let
  # Packages the bot needs
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    python-telegram-bot
  ]);

  botScript = "/home/lewelove/commercial/family-office-bot/bot.py";
in
{
  systemd.services.lab-bot = {
    description = "Telegram Bot for Lab Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Pull the TELEGRAM_TOKEN from our secret file
      EnvironmentFile = "/etc/telegram-bot.env";
      
      # Execute using the virtual python environment
      ExecStart = "${pythonEnv}/bin/python ${botScript}";
      
      # Hardening & Reliability
      Restart = "always";
      RestartSec = "10s";
      DynamicUser = true;
      ReadWritePaths = [ "/var/lib/lab-bot" ];
      StateDirectory = "lab-bot";
      ProtectHome = "read-only";
    };
  };
}
