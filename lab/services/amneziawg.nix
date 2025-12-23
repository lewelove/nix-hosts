{ config, pkgs, ... }:

{

  boot.extraModulePackages = [ config.boot.kernelPackages.amneziawg ];

  environment.systemPackages = with pkgs; [
    amneziawg-tools
    amneziawg-go
  ];

  systemd.services.awg-vpn = {
    description = "AmneziaWG VPN Service";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amneziawg/active.conf";
      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amneziawg/active.conf";
    };
  };
}
