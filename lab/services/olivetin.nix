{ pkgs, ... }:

{
  services.olivetin = {
    enable = true;
    settings = {
      listenAddressSingleHTTPFrontend = "0.0.0.0:1337";
      actions = [
        {
          title = "WAKE HOME COMPUTER";
          icon = "🖥️";
          shell = "${pkgs.wakeonlan}/bin/wakeonlan -i 192.168.1.255 e0:d5:5e:79:c2:d4";
        }
        {
          title = "VPN: START RANDOM / RESTART";
          icon = "🚀";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/awgu";
          timeout = 30;
        }
        {
          title = "VPN: STOP (ISP Mode)";
          icon = "⏹";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/awgd";
          timeout = 30;
        }
        {
          title = "SYSTEM: RESTART PHONE TUNNEL";
          icon = "📱";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/systemctl restart awg-inbound";
          timeout = 30;
        }
      ];
    };
  };

  systemd.services.olivetin.path = [ 
    pkgs.bash 
    pkgs.coreutils 
    pkgs.systemd
    "/run/wrappers" 
    "/run/current-system/sw"
  ];

  security.sudo.extraRules = [
    {
      users = [ "olivetin" ];
      commands = [
        { command = "/run/current-system/sw/bin/awgu"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/awgd"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  networking.firewall.allowedTCPPorts = [ 1337 ];
}
