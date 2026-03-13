{ pkgs, lib, username, dot, ... }:

{
  home-manager.users.${username} = { config, ... }: {
    services.mpd = {
      enable = true;
      musicDirectory = "/mnt/1000xlab/backup-everything/FB2K/Library Historyfied!";
      dbFile = "${config.home.homeDirectory}/.config/mpd/database";
      dataDir = "${config.home.homeDirectory}/.config/mpd";
      playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
      network.startWhenNeeded = true;
      extraConfig = ''
        auto_update "yes"
        
        sticker_file "~/.config/mpd/sticker.sql"
        
        audio_output {
          type            "null"
          name            "Null Sound Server"
        }
      '';
    };
  };
}

