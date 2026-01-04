{ config, pkgs, username, hostname, ... }:

{

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.resolvconf.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

}
