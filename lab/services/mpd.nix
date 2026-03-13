{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/1000xlab/backup-everything/FB2K/Library Historyfied!";
    
    settings = {
      bind_to_address = "127.0.0.1";
      port = "6600";
      
      audio_output = {
        type = "null";
        name = "My Lossless Device";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 6600 ];
}
