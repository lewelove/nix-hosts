{ pkgs, ... }:

{
  # Ensure the tools are available
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

      # --- THE ENCRYPTED PIPE PROTECTION (Priority 50) ---
      # Mark packets leaving port 55555 and force them to bypass the Spain VPN
      PostUp = iptables -t mangle -A OUTPUT -p udp --sport 55555 -j MARK --set-mark 55
      PostUp = ip rule add fwmark 55 priority 50 table main
      PostDown = iptables -t mangle -D OUTPUT -p udp --sport 55555 -j MARK --set-mark 55 || true
      PostDown = ip rule del priority 50 || true

      # --- DECRYPTED TRAFFIC PROTECTION (Priority 100-101) ---
      PostUp = ip rule add to 10.10.10.0/24 priority 100 table main || true
      PostUp = ip rule add to 192.168.1.0/24 priority 101 table main || true
      PostDown = ip rule del priority 100 || true
      PostDown = ip rule del priority 101 || true

      # --- FORWARDING & NAT ---
      PostUp = iptables -A FORWARD -i awg-phone -j ACCEPT || true
      PostUp = iptables -A FORWARD -o awg-phone -j ACCEPT || true
      PostUp = iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -j MASQUERADE || true

      # Safe MSS for Double-VPN
      PostUp = iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1280 || true

      [Peer]
      PublicKey = ZTLbqTILxC72BunEQXnYpYmaxGwsX5lJ2HaAap1UZA4=
      AllowedIPs = 10.10.10.2/32
      EOF

      ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/awg-phone.conf
    '';

    postStop = ''
      ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/awg-phone.conf || true
    '';
  };
}
