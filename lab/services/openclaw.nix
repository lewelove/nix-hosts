{ config, pkgs, lib, inputs, username, hostPath, ... }:

let
  openclawPkg = inputs.openclaw.packages.${pkgs.system}.openclaw;
in
{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = openclawPkg;
      documents = ../tilde/openclaw-docs;

      config = {
        gateway.auth.token = "USE_ENV_VAR"; 
      };

      bundledPlugins.summarize.enable = true;

      instances.default = {
        enable = true;
        systemd.enable = false; 
        config = {
          gateway.auth.token = "USE_ENV_VAR"; 
          channels.telegram = {
            tokenFile = "/home/${username}/.secrets/telegram-token";
            allowFrom = [ 7976595060 ]; 
            groups = {
              "*" = { requireMention = true; };
            };
          };
        };
      };
    };

    systemd.user.services = {
      openclaw-gateway = {
        Unit = {
          Description = "OpenClaw Gateway";
          After = [ "network.target" ];
        };
        Service = {
          Environment = [ "OPENCLAW_GATEWAY_MODE=local" ];
          EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
          ExecStart = "${openclawPkg}/bin/openclaw gateway --allow-unconfigured";
          Restart = "always";
          RestartSec = "3s";
        };
        Install.WantedBy = [ "default.target" ];
      };

      openclaw-instance-default = {
        Unit = {
          Description = "OpenClaw Instance (Default)";
          After = [ "openclaw-gateway.service" ];
          Requires = [ "openclaw-gateway.service" ];
        };
        Service = {
          EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
          # Command to run the bot instance
          ExecStart = "${openclawPkg}/bin/openclaw instance default";
          Restart = "always";
          RestartSec = "3s";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
