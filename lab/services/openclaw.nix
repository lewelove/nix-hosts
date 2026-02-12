{ config, pkgs, lib, inputs, username, hostPath, identity, ... }:

{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.system}.openclaw;
      documents = ../tilde/openclaw-docs;

      config = {
        gateway = {
          mode = "local";
          auth.token = "USE_ENV_VAR"; 
        };
        
        plugins.entries.telegram.enabled = true;

        channels.telegram = {
          enabled = true;
          tokenFile = "/home/${username}/.secrets/telegram-token";
          allowFrom = [ 7976595060 ]; 
          groups = {
            "*" = { requireMention = true; };
          };
        };

        agents.defaults.model.primary = "openrouter/arcee-ai/trinity-large-preview:free";
      };

      bundledPlugins.summarize.enable = true;

      instances.default = {
        enable = true;
        systemd.enable = false; 
        config = {
          gateway.auth.token = "USE_ENV_VAR"; 
          plugins.entries.telegram.enabled = true;
          channels.telegram = {
            enabled = true;
            tokenFile = "/home/${username}/.secrets/telegram-token";
            allowFrom = [ 7976595060 ]; 
          };
          agents.defaults.model.primary = "openrouter/arcee-ai/trinity-large-preview:free";
        };
      };
    };

    systemd.user.services.openclaw-gateway = {
      Unit = {
        Description = "OpenClaw Gateway (Local Mode)";
        After = [ "network.target" ];
      };
      Service = {
        Environment = [ 
          "OPENCLAW_GATEWAY_MODE=local"
          "OPENCLAW_NIX_MODE=1"
          "OPENCLAW_CONFIG_PATH=/home/${username}/.config/openclaw/openclaw.json"
          "OPENCLAW_DOCS_DIR=/home/${username}/nix-hosts/lab/tilde/openclaw-docs"
        ];
        EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
        
        # FIXED: Explicitly pass the token via flag using expansion from the EnvironmentFile.
        # Note: double ''$ is used for Nix escaping.
        ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw gateway --allow-unconfigured --token ''${OPENCLAW_GATEWAY_AUTH_TOKEN}";
        
        Restart = "always";
        RestartSec = "3s";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
