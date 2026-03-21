{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "LibreChat";
  domain = "librechat.localhost";
  port = 3080;
in
{
  networking.hosts."127.0.0.1" = [ domain ];

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb;
  };

  services.nginx.virtualHosts."${domain}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name;
      genericName = "AI Chat Interface";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}";
      icon = "chat";
      terminal = false;
      categories = [ "Network" "Utility" ];
    };

    systemd.user.services.librechat = {
      Unit = {
        Description = "LibreChat Server";
        After = [ "mongodb.service" "network.target" ];
      };

      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/librechat";

        ExecStart = "${pkgs.librechat}/bin/librechat-server";
        Restart = "on-failure";
        RestartSec = "5s";

        WorkingDirectory = "%h/.local/share/librechat";

        Environment = [
          "HOST=127.0.0.1"
          "PORT=${toString port}"
          "MONGO_URI=mongodb://127.0.0.1:27017/librechat"
          
          # Endpoints
          "ENDPOINTS=open_ai"
          "OPENAI_API_BASE_URL=https://openrouter.ai/api/v1"
          "OPENAI_API_KEY=your_openrouter_key_here"

          # Security Keys (Required by LibreChat to start)
          "CREDS_KEY=f39a4d2f00d8e48a1b6a1529184a486e11bc93c0429f57876251b14243171352"
          "CREDS_IV=a1b2c3d4e5f60718293a4b5c6d7e8f90"
          "JWT_SECRET=sk-9f3a2b1c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7a8b9c0d1e"
          "JWT_REFRESH_SECRET=sk-0d1e2f3g4h5i6j7k8l9m0n1o2p3q4r5s6t7u8v9w0x1y2z3a4b5c6d7e8f9g0h1i"
        ];
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
