{ pkgs, ... }:

{
  services.olivetin = {
    enable = true;
    
    settings = {
      # This forces OliveTin to listen on all interfaces (LAN and VPN)
      listenAddressSingleHTTPFrontend = "0.0.0.0:1337";

      actions = [
        {
          title = "VPN: STOP (ISP Mode)";
          icon = "⏹";
          shell = "sudo /run/current-system/sw/bin/awgd";
        }
        {
          title = "VPN: START / SWITCH";
          icon = "🚀";
          shell = "sudo /run/current-system/sw/bin/awgu {{ config_name }}";
          arguments = [
            {
              name = "config_name";
              type = "choice";
              choices = [
                "Spain.conf"
                "Germany.conf"
                "USA.conf"
              ];
            }
          ];
        }
        {
          title = "GATEWAY: FULL STATUS";
          icon = "🔍";
          shell = ''
            echo "--- HOST (ISP) ---"
            ${pkgs.curl}/bin/curl -s http://ip-api.com/line | head -n 14
            echo ""
            echo "--- TUNNEL (VPN) ---"
            if ${pkgs.systemd}/bin/systemctl is-active --quiet awg-vpn; then
              ${pkgs.curl}/bin/curl -s --interface active http://ip-api.com/line | head -n 14
            else
              echo "VPN Service is DOWN"
            fi
          '';
        }
        {
          title = "SYSTEM: RESTART PHONE TUNNEL";
          icon = "📱";
          shell = "sudo /run/current-system/sw/bin/systemctl restart awg-inbound";
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
        { command = "/run/current-system/sw/bin/systemctl restart awg-inbound"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  networking.firewall.allowedTCPPorts = [ 1337 ];
}
