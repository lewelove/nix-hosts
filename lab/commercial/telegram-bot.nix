{ pkgs, ... }:

let
  botRepo = /home/lewelove/commercial/family-office-bot;
in
{
  systemd.services.lab-bot = {
    description = "Family Office Telegram Bot";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile = "/etc/telegram-bot.env";
      
      ExecStart = "${(pkgs.callPackage "${botRepo}/flake.nix" {}).packages.${pkgs.system}.default}/bin/family-office-bot";
      
      Restart = "always";
      RestartSec = "10s";

      DynamicUser = true;
      StateDirectory = "lab-bot";
      WorkingDirectory = "/var/lib/lab-bot";
    };
  };
}
