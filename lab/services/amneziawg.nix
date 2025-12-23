{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    amneziawg-tools 
    amneziawg-go 
    iptables
  ];

  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    
    # Giving the service the same toolset as your user shell
    path = with pkgs; [ 
      amneziawg-tools
      amneziawg-go
      iproute2
      iptables
      openresolv
      procps
    ];

    # Ensure it uses the userspace implementation found in the path above
    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf";
      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf";
    };
  };
}
