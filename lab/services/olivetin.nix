{ pkgs, ... }:

{
  services.olivetin = {
    enable = true;
    settings = {
      listenAddressSingleHTTPFrontend = "0.0.0.0:1337";
      actions = [
        {
          title = "VPN: RESTART";
          icon = "🚀";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/awgu";
        }
        {
          title = "VPN: STOP";
          icon = "⏹";
          shell = "/run/wrappers/bin/sudo /run/current-system/sw/bin/awgd";
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
