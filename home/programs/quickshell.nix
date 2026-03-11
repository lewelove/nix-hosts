{ pkgs, username, dot, ... }:

{
  home-manager.users.${username} = { config, ... }: {
    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell Desktop Shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell/hypr-ref/shell.qml";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    home.file.".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/quickshell";
  };
}
