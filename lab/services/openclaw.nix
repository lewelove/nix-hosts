{ config, pkgs, inputs, username, ... }:

{
  # Add the OpenClaw Home Manager module to the user configuration
  home-manager.users.${username} = {
    imports = [ inputs.openclaw.homeManagerModules.openclaw ];

    programs.openclaw = {
      enable = true;

      package = inputs.nix-openclaw.packages.${pkgs.system}.openclaw;
      
      # Points to the directory where you keep your bot's identity files
      documents = ../tilde/openclaw-docs;

      config = {
        gateway = {
          mode = "local";
          auth.token = "change-this-to-a-secure-random-string"; 
        };

        channels.telegram = {
          # Path to a file containing your bot token (create this manually on the server)
          tokenFile = "/home/${username}/.secrets/telegram-token";
          # Your Telegram User ID (get it from @userinfobot)
          allowFrom = [ 7976595060 ]; 
          groups = {
            "*" = { requireMention = true; };
          };
        };
      };

      # First-party plugins to give the bot "senses"
      bundledPlugins = {
        summarize.enable = true;   # Summarize URLs
      };

      instances.default = {
        enable = true;
        systemd.enable = true;
      };
    };
  };
}
