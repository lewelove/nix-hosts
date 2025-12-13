{ pkgs, config, lib, ... }:

let
  # Define the custom package pointing to your fork
  listenbrainz-mpd-90-no4m = pkgs.listenbrainz-mpd.overrideAttrs (old: rec {
    pname = "listenbrainz-mpd-90-no4m";
    version = "git";

    src = pkgs.fetchFromGitea {
      domain = "codeberg.org";
      owner = "lewelove";
      repo = "listenbrainz-mpd-90-no4m";
      rev = "main"; # Or use a specific commit hash for stability
      hash = "sha256-ePYk33SuGTiTRquUcVZTdkx4bXayCpWkEK5a/CC0+Yo="; # STEP 1: Change this after first error
    };

    # Invalidate the vendor hash since the source code changed
    cargoHash = lib.fakeHash; # STEP 2: Change this after second error
  });
in
{

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

  # Define the Systemd User Service with the consistent name
  systemd.user.services.listenbrainz-mpd-90-no4m = {
    Unit = {
      Description = "ListenBrainz MPD Client (90% Threshold, No 4m Limit)";
      After = [ "mpd.service" ];
      Wants = [ "mpd.service" ];
    };

    Service = {
      # The binary name inside Cargo.toml usually remains "listenbrainz-mpd"
      # even if the package name changed, unless you edited Cargo.toml name.
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

}
