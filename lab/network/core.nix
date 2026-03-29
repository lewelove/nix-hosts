{ config, pkgs, username, hostname, ... }:

{

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.resolvconf.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    allowedTCPPorts = [ 80 443 ];
    extraCommands = ''
      iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
      iptables -A INPUT -s 10.10.10.0/24 -j ACCEPT
    '';
  };

  boot.kernel.sysctl = {
    # Forwarding
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;

    # --- HARDENING ---
    # Enable TCP Syncookies (Protection against SYN flood attacks)
    "net.ipv4.tcp_syncookies" = 1;

    # Ignore ICMP broadcast requests (Prevents Smurf attacks)
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;

    # Ignore bogus ICMP error responses
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Disable source routing (Prevents malicious pathing)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;

    # Disable ICMP redirects (Prevents man-in-the-middle routing spoofing)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
  };

}
