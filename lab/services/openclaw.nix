{ config, pkgs, lib, inputs, username, hostPath, ... }:

{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.system}.openclaw;
      # Bundles documentation into the Nix store
      documents = ../tilde/openclaw-docs;

      config = {
        gateway.auth.token = "USE_ENV_VAR"; 
      };

      bundledPlugins.summarize.enable = true;

      instances.default = {
        enable = true;
        # We disable the module's automatic systemd to avoid version-mismatch bugs
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

    systemd.user.services.openclaw-gateway = {
      Unit = {
        Description = "OpenClaw Gateway (Local Mode)";
        After = [ "network.target" ];
      };
      Service = {
        # Local mode tells the gateway to run the bot/agent logic itself
        Environment = [ "OPENCLAW_GATEWAY_MODE=local" ];
        # Injects the real OPENCLAW_GATEWAY_AUTH_TOKEN
        EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
        
        # We call the binary without subcommands like 'instance' or 'run'
        # We removed --allow-unconfigured so it actually uses the Home Manager config
        ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw gateway";
        
        Restart = "always";
        RestartSec = "3s";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
