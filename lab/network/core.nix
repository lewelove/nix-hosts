{ ... }:

{

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall.allowedUDPPorts = [ 55555 ];
  networking.firewall.checkReversePath = "loose";

  networking.localCommands = ''
    ip rule add to 10.10.10.0/24 priority 400 table main || true
    ip rule add to 192.168.1.0/24 priority 401 table main || true
  '';

}
