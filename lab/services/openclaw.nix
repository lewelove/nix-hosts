{ config, pkgs, lib, inputs, username, hostPath, ... }:

{
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.system}.openclaw;
      documents = "${hostPath}/tilde/openclaw-docs";

      config = {
        gateway = {
          auth.token = "change-this-to-a-secure-random-string"; 
        };
      };

      bundledPlugins.summarize.enable = true;

      instances.default = {
        enable = true;
        systemd.enable = true;
        config = {
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

    systemd.user.services.openclaw-gateway = {
      Service = {
        # 1. FORCE THE MODE VIA ENV VAR
        Environment = [ 
          "OPENCLAW_GATEWAY_MODE=local" 
        ];
        
        # 2. Add the --allow-unconfigured flag just in case the binary is being stubborn
        ExecStart = lib.mkForce "${config.home-manager.users.${username}.programs.openclaw.package}/bin/openclaw gateway --allow-unconfigured";
        
        EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
