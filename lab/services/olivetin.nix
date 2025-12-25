{ pkgs, ... }:

{
  services.olivetin = {
    enable = true;
    settings = {
      listenAddressSingleHTTPFrontend = "0.0.0.0:1337";
      actions = [
        {
          title = "VPN: START RANDOM / RESTART";
          icon = "🚀";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/awgu";
        }
        {
          title = "VPN: STOP (ISP Mode)";
          icon = "⏹";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/awgd";
        }
        {
          title = "SYSTEM: RESTART PHONE TUNNEL";
          icon = "📱";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/systemctl restart awg-inbound";
        }
      ];
    };
  };

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
