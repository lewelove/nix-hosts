{ config, pkgs, lib, inputs, username, hostPath, ... }:

let
  # Extract the specific daemon packages from the flake
  # These are wrappers pre-configured for the 'default' name
  gatewayPkg = inputs.openclaw.packages.${pkgs.system}.openclaw-gateway-default;
  instancePkg = inputs.openclaw.packages.${pkgs.system}.openclaw-instance-default;
in
{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.system}.openclaw; # CLI tool
      documents = ../tilde/openclaw-docs;

      config = {
        gateway.auth.token = "USE_ENV_VAR"; 
      };

      bundledPlugins.summarize.enable = true;

      instances.default = {
        enable = true;
        # Disable the module's automatic systemd generation to avoid the known bug
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
          # Use the specialized gateway binary
          ExecStart = "${gatewayPkg}/bin/openclaw-gateway-default gateway";
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
          # Use the specialized instance binary (no 'run' or 'start' needed)
          ExecStart = "${instancePkg}/bin/openclaw-instance-default";
          Restart = "always";
          RestartSec = "3s";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
