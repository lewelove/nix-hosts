{ pkgs, ... }:

let
  awgd = pkgs.writeShellApplication {
    name = "awgd";
    runtimeInputs = with pkgs; [ systemd coreutils ];
    text = ''
      sudo systemctl stop awg-vpn
      echo ":: VPN Stopped. Host is back to ISP-Only mode."
    '';
  };
in
{
  environment.systemPackages = [ awgd ];
}
