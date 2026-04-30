{ pkgs, lib, username, dot, ... }:

let
  listenbrainz-mpd-90-no4m = pkgs.listenbrainz-mpd.overrideAttrs (old: rec {
    pname = "listenbrainz-mpd-90-no4m";
    version = "git";
    src = pkgs.fetchFromGitea {
      domain = "codeberg.org";
      owner = "lewelove";
      repo = "listenbrainz-mpd-90-no4m";
      rev = "main";
      hash = "sha256-ZlELdjaJQukMZfDotmyuPW0S4D2zsPv++vQDOXnm/Yk=";
    };

    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src pname version;
      hash = "sha256-1x3F2TqNlqwfPUvLwU8ac4aEeEwpIy5gEyxRBC0Q5YM=";
    };
  });
in
{
  home-manager.users.${username} = { config, ... }: {
    services.mpd = {
      enable = true;
      musicDirectory = "/run/media/${config.home.username}/1000xhome/backup-everything/FB2K/Library Historyfied!";
      dbFile = "${config.home.homeDirectory}/.config/mpd/database";
      dataDir = "${config.home.homeDirectory}/.config/mpd";
      playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
      network.startWhenNeeded = true;
      extraConfig = ''
        auto_update "yes"
        
        sticker_file "~/.config/mpd/sticker.sql"
        
        audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
          always_on       "yes"
        }
      '';
    };

    systemd.user.services.listenbrainz-mpd-90-no4m = {
      Unit = {
        Description = "ListenBrainz MPD Client (90% Threshold, No 4m Limit)";
        After = [ "mpd.service" ];
        Wants = [ "mpd.service" ];
      };
      Service = {
        ExecStart = "${listenbrainz-mpd-90-no4m}/bin/listenbrainz-mpd";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "XDG_CONFIG_HOME=${config.home.homeDirectory}/.config"
          "LISTENBRAINZ_MPD_LOG=debug"
        ];
      };
      Install.WantedBy = [ "default.target" ];
    };

    home.file = {
      ".config/rmpc".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/rmpc";
      ".config/listenbrainz-mpd".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/listenbrainz-mpd";
    };
  };
}
