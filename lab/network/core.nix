{ config, pkgs, username, hostname, ... }:

{

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.resolvconf.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    allowedTCPPorts = [ 80 443 ];
    # extraCommands = ''
    #   # Allow all traffic from Home Subnet
    #   iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
    #   # Allow all traffic from your AmneziaWG Phone Subnet
    #   iptables -A INPUT -s 10.10.10.0/24 -j ACCEPT
    # '';
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

}
