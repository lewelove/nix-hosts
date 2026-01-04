{ config, pkgs, ... }:

{

  services.nfs.server.enable = true;

  services.nfs.server.exports = ''
    /mnt/1000xlab/downloads 192.168.1.0/24(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=1000,anongid=100)
  '';

  networking.firewall.allowedTCPPorts = [ 2049 ];

}
