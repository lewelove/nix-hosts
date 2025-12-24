{ ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    # Loose RP Filter is mandatory for nested VPN routing
    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;
    "net.ipv4.conf.enp2s0.rp_filter" = 2;
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 55555 ];
    checkReversePath = "loose";
  };
}
