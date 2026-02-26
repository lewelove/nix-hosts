{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "Excalidraw";
  icon = "excalidraw";
  domain = "excalidraw.localhost";
  port = 5000;
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
      genericName = "Whiteboard Tool";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}";
      terminal = false;
      categories = [
        "Graphics"
        "Office"
      ];
    };

    systemd.user.services.excalidraw = {
      Unit = {
        Description = "Excalidraw Local Container";
        After = [ "network.target" ];
      };

      Service = {
        ExecStartPre = "-${pkgs.podman}/bin/podman rm -f excalidraw";
        ExecStart = "${pkgs.podman}/bin/podman run --name excalidraw --replace -p 127.0.0.1:${toString port}:80 docker.io/excalidraw/excalidraw:latest";
        ExecStop = "${pkgs.podman}/bin/podman stop excalidraw";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
