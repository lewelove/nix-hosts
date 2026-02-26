{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "VS Code";
  icon = "code";
  domain = "vscode.localhost";
  port = 4444;
in
{
  networking.hosts."127.0.0.1" = [ domain ];

  services.nginx.virtualHosts."${domain}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  home-manager.users.${username} = {
    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "Web-based IDE";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}";
      terminal = false;
      categories = [
        "Development"
        "TextEditor"
      ];
    };

    systemd.user.services.code-server = {
      Unit = {
        Description = "VS Code Server (Local FOSS)";
        After = [ "network.target" ];
      };

      Service = {
        ExecStart = ''
          ${pkgs.code-server}/bin/code-server \
            --bind-addr 127.0.0.1:${toString port} \
            --auth none \
            --user-data-dir %h/.config/code-server \
            --extensions-dir %h/.config/code-server/extensions \
            --disable-telemetry \
            --disable-update-check \
            --ignore-last-opened
        '';
        Restart = "always";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
