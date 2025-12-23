{ config, pkgs, ... }:

{

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--advertise-exit-node"
      "--accept-dns=true"
    ];
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

}
