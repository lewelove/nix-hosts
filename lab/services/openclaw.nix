{ config, pkgs, lib, inputs, username, hostPath, identity, ... }:

{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    # Fix: Use an overlay to set priority on the underlying packages.
    # This resolves the 'is-docker' collision between summarize and oracle.
    nixpkgs.overlays = [
      (final: prev: {
        # We try to apply priority to these names. 
        # The OpenClaw module will use these versions when installing plugins.
        summarize = if prev ? summarize then lib.hiPrio prev.summarize else prev;
        oracle = if prev ? oracle then lib.lowPrio prev.oracle else prev;
      })
    ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.stdenv.hostPlatform.system}.openclaw;
      documents = ../tilde/openclaw-docs;

      config = {
        gateway.mode = "local";
        gateway.auth.token = "USE_ENV_VAR"; 

        # SOURCE: Force plugin enablement to override any defaults
        plugins.entries.telegram.enabled = lib.mkForce true;

        channels.telegram = {
          enabled = lib.mkForce true;
          # We now provide the token via environment variable for better security
          allowFrom = [ 7976595060 ]; 
          groups = { "*" = { requireMention = true; }; };
        };

        agents.defaults.model.primary = "openrouter/arcee-ai/trinity-large-preview:free";
      };

      bundledPlugins = {
        summarize.enable = true;
        oracle.enable = true;
      };

      instances.default = {
        enable = true;
        systemd.enable = false; 
        config = {
          gateway.auth.token = "USE_ENV_VAR"; 
          plugins.entries.telegram.enabled = lib.mkForce true;
          channels.telegram.enabled = lib.mkForce true;
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
          "OPENCLAW_CONFIG_PATH=/home/${username}/.openclaw/openclaw.json"
          "OPENCLAW_DOCS_DIR=/home/${username}/nix-hosts/lab/tilde/openclaw-docs"
        ];
        EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
        
        # Token is passed via \${} to escape Nix interpolation.
        ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw gateway --allow-unconfigured --token \${OPENCLAW_GATEWAY_TOKEN}";
        
        Restart = "always";
        RestartSec = "3s";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
