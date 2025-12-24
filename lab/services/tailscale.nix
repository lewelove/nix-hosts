{ config, pkgs, ... }:

{

  services.tailscale = {
    enable = true;
    port = 55555;
    extraUpFlags = [
      "--advertise-exit-node"
      "--accept-dns=true"
    ];
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    extraCommands = ''
      ip rule add to 100.64.0.0/10 lookup 52 priority 500 || true
      iptables -t mangle -A FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu || true
    '';
    extraStopCommands = ''
      ip rule del to 100.64.0.0/10 lookup 52 || true
      iptables -t mangle -D FORWARD -o active -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu || true
    '';
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

}
