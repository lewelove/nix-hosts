{ config, pkgs, lib, inputs, username, hostPath, identity, ... }:

{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    # Install plugins explicitly from flake inputs.
    # We lower the priority of 'oracle' so its colliding files (like is-docker)
    # yield to 'summarize'. This resolves the buildEnv error cleanly.
    home.packages = [
      inputs.summarize.packages.${pkgs.stdenv.hostPlatform.system}.default
      (lib.lowPrio inputs.oracle.packages.${pkgs.stdenv.hostPlatform.system}.default)
    ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.stdenv.hostPlatform.system}.openclaw;
      documents = ../tilde/openclaw-docs;

      # Disable the module's internal bundling to avoid double-installation
      bundledPlugins = {
        summarize.enable = false;
        oracle.enable = false;
      };

      config = {
        gateway.mode = "local";
        gateway.auth.token = "USE_ENV_VAR"; 

        # We manually enable the plugins in the config so OpenClaw knows to use them.
        # Since we added them to home.packages, they are already in the PATH.
        plugins.entries = {
          telegram.enabled = lib.mkForce true;
          summarize.enabled = true;
          oracle.enabled = true;
        };

        channels.telegram = {
          enabled = lib.mkForce true;
          # We now provide the token via environment variable for better security
          allowFrom = [ 7976595060 ]; 
          groups = { "*" = { requireMention = true; }; };
        };

        agents.defaults.model.primary = "openrouter/arcee-ai/trinity-large-preview:free";
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
