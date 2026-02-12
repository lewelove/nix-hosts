{ config, pkgs, lib, inputs, username, hostPath, ... }:

{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.system}.openclaw;
      documents = ../tilde/openclaw-docs;

      config = {
        gateway = {
          # Placeholder for Nix evaluation; real token is injected via Systemd
          auth.token = "USE_ENV_VAR"; 
        };
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
          ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw gateway --allow-unconfigured";
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
          # Removed the 'start'/'run' subcommand
          ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw --instance default";
          Restart = "always";
          RestartSec = "3s";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
