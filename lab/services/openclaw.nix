{ config, pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {

    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;
      package = inputs.openclaw.packages.${pkgs.system}.openclaw;
      documents = ../tilde/openclaw-docs;

      gateway = {
        enable = true;
        config = {
          gateway = {
            mode = "local";
            auth.token = "change-this-to-a-secure-random-string"; 
          };
        };
      };

      bundledPlugins = {
        summarize.enable = true;
      };

      instances.default = {
        enable = true;
        systemd.enable = true;
        config = {
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
        EnvironmentFile = [ "/home/${username}/.secrets/openclaw.env" ];
      };
    };
  };
}
