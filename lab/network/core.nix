{ ... }:

{

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall.allowedUDPPorts = [ 55555 ];
  networking.firewall.checkReversePath = "loose";

}
