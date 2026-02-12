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
          # Use a placeholder. The real value is loaded via systemd EnvironmentFile
          auth.token = "USE_ENV_VAR"; 
        };
      };

      bundledPlugins.summarize.enable = true;

      instances.default = {
        enable = true;
        systemd.enable = false; # We manage the units manually below
        config = {
          gateway.address = "http://127.0.0.1:18789";
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
          # This forces local mode
          Environment = [ "OPENCLAW_GATEWAY_MODE=local" ];
          # This loads your REAL token from the local file
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
          # We load the same secret file so the Instance has the token to talk to the Gateway
          EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
          ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw run --instance default";
          Restart = "always";
          RestartSec = "3s";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
