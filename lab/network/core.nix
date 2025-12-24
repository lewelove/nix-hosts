{ ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    # Required for stateful routing to prevent the kernel from dropping "asymmetric" packets
    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 55555 ];
    # We use 'loose' for extra safety, but the 'rp_filter' sysctl above is the real fix
    checkReversePath = "loose";
  };
}
