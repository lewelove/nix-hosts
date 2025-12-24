{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ amneziawg-tools amneziawg-go ];

  systemd.services.awg-inbound = {
    description = "AmneziaWG Inbound Server for Phone";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    path = with pkgs; [ amneziawg-tools amneziawg-go iproute2 iptables ];
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

      # --- PROFESSIONAL DESTINATION-BASED ROUTING ---
      
      # 1. Protect the Handshake: Mark the 'pipe' itself so it bypasses all VPNs
      PostUp = iptables -t mangle -A OUTPUT -p udp --sport 55555 -j MARK --set-mark 0x55
      PostUp = ip rule add fwmark 0x55 priority 10 table main
      PostDown = iptables -t mangle -D OUTPUT -p udp --sport 55555 -j MARK --set-mark 0x55 || true
      PostDown = ip rule del priority 10 || true

      # 2. Local Destination Protection: If traffic is headed TO the phone or TO the LAN, 
      # use the 'main' table. This beats Spain (98/99) but ONLY for local destinations.
      PostUp = ip rule add to 10.10.10.0/24 priority 11 table main
      PostUp = ip rule add to 192.168.1.0/24 priority 12 table main
      PostDown = ip rule del priority 11 || true
      PostDown = ip rule del priority 12 || true

      # --- FORWARDING & NAT ---
      PostUp = iptables -A FORWARD -i awg-phone -j ACCEPT || true
      PostUp = iptables -A FORWARD -o awg-phone -j ACCEPT || true
      PostDown = iptables -D FORWARD -i awg-phone -j ACCEPT || true
      PostDown = iptables -D FORWARD -o awg-phone -j ACCEPT || true

      PostUp = iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -j MASQUERADE || true
      PostDown = iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -j MASQUERADE || true

      # MSS Clamping (Double-VPN Safety)
      PostUp = iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1280 || true
      PostDown = iptables -t mangle -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1280 || true

      [Peer]
      PublicKey = ZTLbqTILxC72BunEQXnYpYmaxGwsX5lJ2HaAap1UZA4=
      AllowedIPs = 10.10.10.2/32
      EOF

      ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/awg-phone.conf
    '';

    postStop = ''
      ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/awg-phone.conf || true
      ${pkgs.iproute2}/bin/ip rule del priority 10 || true
      ${pkgs.iproute2}/bin/ip rule del priority 11 || true
      ${pkgs.iproute2}/bin/ip rule del priority 12 || true
    '';
  };
}
