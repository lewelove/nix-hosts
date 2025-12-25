{ pkgs, ... }:

{

  networking.firewall.allowedUDPPorts = [ 55555 ];

  environment.systemPackages = with pkgs; [ 
    amneziawg-tools 
    amneziawg-go 
  ];

  systemd.services.awg-inbound = {
    description = "AmneziaWG Inbound Server for Phone";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    path = with pkgs; [ 
      amneziawg-tools
      amneziawg-go
      iproute2
      iptables
    ];

    # We use 'amneziawg-go' for userspace obfuscation support
    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    # REPLACE: <LAB_INBOUND_PRIVATE_KEY> and <PHONE_PUBLIC_KEY>
    script = ''
      mkdir -p /etc/amneziawg
      cat <<EOF > /etc/amneziawg/awg-phone.conf
      [Interface]
      Address = 10.10.10.1/24
      ListenPort = 55555
      PrivateKey = gKXCI1S7lGuxEVkGuu/7ASdeaUKxxTPDiQwXr5lpp0M=
      
      Jc = 4
      Jmin = 40
      Jmax = 70
      S1 = 44
      S2 = 98
      H1 = 1
      H2 = 2
      H3 = 3
      H4 = 4

      [Peer]
      PublicKey = ZTLbqTILxC72BunEQXnYpYmaxGwsX5lJ2HaAap1UZA4=
      AllowedIPs = 10.10.10.2/32
      EOF

      ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/awg-phone.conf
    '';

    postStop = ''
      ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/awg-phone.conf
    '';
  };
}
