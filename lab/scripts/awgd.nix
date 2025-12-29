{ pkgs, ... }:

let
  awgd = pkgs.writeShellApplication {
    name = "awgd";
    runtimeInputs = with pkgs; [ systemd coreutils ];
    text = ''
      sudo systemctl stop awg-vpn
      if INFO=$(curl -s --max-time 5 http://ip-api.com/json); then
        IP=$(echo "$INFO" | jq -r .query)
        COUNTRY=$(echo "$INFO" | jq -r .country)
        echo ":: VPN Stopped: $IP ($COUNTRY)"
      else
        echo ":: ERROR: ISP check failed"
        exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ awgd ];
}
