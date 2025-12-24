{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ amneziawg-tools amneziawg-go ];

  systemd.services.awg-inbound = {
    description = "AmneziaWG Inbound Server for Phone";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ amneziawg-tools amneziawg-go iproute2 iptables ];
    environment.WG_QUICK_USERSPACE_IMPLEMENTATION = "amneziawg-go";
    serviceConfig = { Type = "oneshot"; RemainAfterExit = true; };

    script = ''
      mkdir -p /etc/amneziawg
      cat <<EOF > /etc/amneziawg/awg-phone.conf
      [Interface]
      Address = 10.10.10.1/24
      ListenPort = 55555
      PrivateKey = gKXCI1S7lGuxEVkGuu/7ASdeaUKxxTPDiQwXr5lpp0M=
      
      # Mark the encrypted 'pipe' packets so we can route them via ISP
      FwMark = 51820

      Jc = 4
      Jmin = 40
      Jmax = 70
      S1 = 44
      S2 = 98
      H1 = 1
      H2 = 2
      H3 = 3
      H4 = 4

      # --- DETERMINISTIC ROUTING ---
      # 1. Force Handshake 'Pipe' (Mark 51820) to use ISP (Priority 100)
      PostUp = ip rule add fwmark 51820 priority 100 table main
      PostDown = ip rule del priority 100 || true

      # 2. Force Decrypted local replies to stay local (Priority 101-102)
      PostUp = ip rule add to 10.10.10.0/24 priority 101 table main
      PostUp = ip rule add to 192.168.1.0/24 priority 102 table main
      PostDown = ip rule del priority 101 || true
      PostDown = ip rule del priority 102 || true

      # 3. Standard Forwarding & NAT
      PostUp = iptables -A FORWARD -i awg-phone -j ACCEPT
      PostUp = iptables -A FORWARD -o awg-phone -j ACCEPT
      PostUp = iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -j MASQUERADE
      PostUp = iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1280
      EOF

      ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/awg-phone.conf
    '';

    postStop = ''
      ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/awg-phone.conf || true
    '';
  };
}
