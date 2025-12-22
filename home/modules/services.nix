{ pkgs, config, lib, ... }:

let
  listenbrainz-mpd-90-no4m = pkgs.listenbrainz-mpd.overrideAttrs (old: rec {
    pname = "listenbrainz-mpd-90-no4m";
    version = "git";

    src = pkgs.fetchFromGitea {
      domain = "codeberg.org";
      owner = "lewelove";
      repo = "listenbrainz-mpd-90-no4m";
      rev = "main";
      hash = "sha256-ePYk33SuGTiTRquUcVZTdkx4bXayCpWkEK5a/CC0+Yo=";
    };

    cargoHash = lib.fakeHash;
  });
in
{

  # --- MPD Service ---
  services.mpd = {
    enable = true;
    
    musicDirectory = "/mnt/drives/hdd1000.1/backup-everything/FB2K/Library Historyfied!";
    
    dbFile = "${config.home.homeDirectory}/.config/mpd/database";
    
    dataDir = "${config.home.homeDirectory}/.config/mpd";
    playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
    
    extraConfig = ''
      auto_update "yes"
      
      sticker_file "~/.config/mpd/sticker.sql"
      
      audio_output {
        type            "pipewire"
        name            "PipeWire Sound Server"
      }
    '';

    network.startWhenNeeded = true;
  };

  # --- ListenBrainz MPD Scrobble Service ---
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

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # --- SWWW Wallpaper Daemon ---
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland Wallpaper Daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
      Type = "simple";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # --- Wlsunset ---
  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Day/Night Gamma Adjuster";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -S 08:00 -s 21:00 -d 3600 -t 4000";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # --- Quickshell ---
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell Desktop Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      # %h is systemd shorthand for home directory
      ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell/hypr-ref/shell.qml";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
