{ config, pkgs, lib, inputs, username, hostPath, identity, ... }:

let
  # Access the packages directly from the flake inputs
  # We use the system-specific package set
  openclawPkgs = inputs.openclaw.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = openclawPkgs.openclaw;
      documents = ../tilde/openclaw-docs;

      # FIXED: We disable 'bundledPlugins' because they cause the PATH collision.
      # Instead, we define them manually in the config section below.
      bundledPlugins = {
        summarize.enable = false;
        oracle.enable = false;
      };

      config = {
        gateway.mode = "local";
        gateway.auth.token = "USE_ENV_VAR"; 

        # Manually enable and point to the plugin store paths.
        # This bypasses the Home Manager "install to PATH" logic, avoiding collisions.
        plugins.entries = {
          telegram.enabled = lib.mkForce true;
          
          summarize = {
            enabled = true;
            # Point directly to the binary in the nix store
            path = "${openclawPkgs.summarize}/bin/summarize";
          };
          
          oracle = {
            enabled = true;
            # Point directly to the binary in the nix store
            path = "${openclawPkgs.oracle}/bin/oracle";
          };
        };

        channels.telegram = {
          enabled = lib.mkForce true;
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
        
        ExecStart = "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw gateway --allow-unconfigured --token \${OPENCLAW_GATEWAY_TOKEN}";
        
        Restart = "always";
        RestartSec = "3s";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
