{ config, pkgs, inputs, username, ... }:

{

  home-manager.users.${username} = {

    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;

      package = inputs.openclaw.packages.${pkgs.system}.openclaw;
      
      documents = ../tilde/openclaw-docs;

      # 1. Gateway Global Configuration
      # This generates the configuration for the standalone gateway service.
      config = {
        gateway = {
          mode = "local";
          auth.token = "change-this-to-a-secure-random-string"; 
        };
      };

      bundledPlugins = {
        summarize.enable = true;
      };

      # 2. Worker Instance Configuration
      # This handles the connection to Telegram.
      instances.default = {
        enable = true;
        systemd.enable = true;
        config = {
          # The worker needs the same token to talk to the gateway defined above
          gateway.auth.token = "change-this-to-a-secure-random-string";

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

    # Environment variables for the gateway (OpenAI keys, etc)
    systemd.user.services.openclaw-gateway = {
      Service = {
        EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
      };
    };
  };

}
