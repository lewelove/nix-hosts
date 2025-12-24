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
      FwMark = 55555

      Jc = 4
      Jmin = 40
      Jmax = 70
      S1 = 44
      S2 = 98
      H1 = 1
      H2 = 2
      H3 = 3
      H4 = 4

      # 1. Pipe Protection: Force handshake to ISP
      PostUp = ip rule add fwmark 55555 priority 10 table main || true
      # 2. Local Access: Lab must always find the phone in 'main'
      PostUp = ip rule add to 10.10.10.0/24 priority 11 table main || true
      
      # 3. Decrypted Forwarding & NAT
      PostUp = iptables -A FORWARD -i awg-phone -j ACCEPT || true
      PostUp = iptables -A FORWARD -o awg-phone -j ACCEPT || true
      PostUp = iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -j MASQUERADE || true
      PostUp = iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1280 || true
      EOF

      ${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/awg-phone.conf
    '';

    postStop = ''
      ${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/awg-phone.conf || true
      ip rule del priority 10 || true
      ip rule del priority 11 || true
    '';
  };
}
