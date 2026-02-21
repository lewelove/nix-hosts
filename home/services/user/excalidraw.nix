{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    systemd.user.services.excalidraw = {
      Unit = {
        Description = "Excalidraw Local Container";
        After = [ "network.target" ];
      };

      Service = {
        ExecStartPre = "-${pkgs.podman}/bin/podman rm -f excalidraw";
        ExecStart = "${pkgs.podman}/bin/podman run --name excalidraw --replace -p 127.0.0.1:5000:80 docker.io/excalidraw/excalidraw:latest";
        ExecStop = "${pkgs.podman}/bin/podman stop excalidraw";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
