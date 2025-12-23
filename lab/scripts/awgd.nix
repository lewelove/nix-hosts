{ pkgs, ... }:

let
  awgd = pkgs.writeShellApplication {
    name = "awgd";
    runtimeInputs = with pkgs; [ systemd gum ];
    text = ''
      echo ":: Bringing VPN down..."
      sudo systemctl stop awg-vpn
      
      echo ":: Current IP (Local ISP):"
      curl -s ip-api.com/line | gum style --foreground 1
    '';
  };
in
{
  environment.systemPackages = [ awgd ];
}
