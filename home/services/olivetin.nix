{ pkgs, username, ... }:

let
  olivetinConfigDir = pkgs.writeTextDir "config.yaml" ''
    listenAddressSingleHTTPFrontend: 0.0.0.0:1337
    actions:
      - title: "Play / Pause"
        icon: "⏯️"
        shell: "${pkgs.wtype}/bin/wtype -k XF86AudioPlay"

      - title: "Volume +3%"
        icon: "🔊"
        shell: "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+"

      - title: "Volume -3%"
        icon: "🔉"
        shell: "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 1337 ];

  home-manager.users.${username} = {
    systemd.user.services.olivetin = {
      Unit = {
        Description = "OliveTin Control Interface";
        After = [ "graphical-session.target" "pipewire.service" ];
        Wants = [ "pipewire.service" ];
      };

      Service = {
        ExecStart = "${pkgs.olivetin}/bin/OliveTin -configdir ${olivetinConfigDir}";
        Restart = "on-failure";
        RestartSec = "5s";
        
        Environment = [
          "PATH=${pkgs.bash}/bin:${pkgs.coreutils}/bin:$PATH"
        ];
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
