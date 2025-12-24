{ ... }:

{
  # 1. Enable Packet Forwarding
  # This allows the Lab to act as a bridge between the phone and local services.
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # 2. Open the Firewall
  # Port 55555 is our 'Front Door'. Protocol MUST be UDP for WireGuard.
  networking.firewall.allowedUDPPorts = [ 55555 ];

  # 3. Loose Reverse Path Filtering
  # Essential for VPNs. It prevents the kernel from dropping packets that 
  # arrive on 'awg-phone' but are destined for the local network.
  networking.firewall.checkReversePath = "loose";
}
