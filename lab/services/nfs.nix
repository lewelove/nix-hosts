{ config, pkgs, ... }:

{

  services.nfs.server = {
    enable = true;
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;

    exports = ''
      /mnt/1000xlab/downloads 192.168.1.0/24(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=993,anongid=990)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 ];

}
