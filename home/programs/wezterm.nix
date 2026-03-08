{ pkgs, lib, username, identity, ... }:

let
  dotfolder = "${identity.repoPath}/dotfiles/.config/wezterm";
in
{
  environment.systemPackages = [ pkgs.wezterm ];

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink dotfolder;

    systemd.user.services.wezterm-mux = {
      Unit = {
        Description = "WezTerm Mux Server";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wezterm}/bin/wezterm-mux-server";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
