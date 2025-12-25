{ pkgs, ... }:

let
  awgu = pkgs.writeShellApplication {
    name = "awgu";
    runtimeInputs = with pkgs; [ coreutils systemd jq curl findutils ];
    text = ''
      SOURCE_DIR="/etc/amneziawg/configs"
      ACTIVE_LINK="/etc/amneziawg/active.conf"
      SELECTED="''${1:-}"

      if [ -z "$SELECTED" ]; then
        SELECTED=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.conf" -printf "%f\n" | shuf -n 1)
      fi

      if [[ "$SELECTED" != *.conf ]]; then
        SELECTED="$SELECTED.conf"
      fi

      if [ ! -f "$SOURCE_DIR/$SELECTED" ]; then
        echo ":: Error: $SELECTED not found"
        exit 1
      fi

      sudo ln -sf "$SOURCE_DIR/$SELECTED" "$ACTIVE_LINK"
      sudo systemctl restart awg-vpn
      
      sleep 2

      if INFO=$(curl -s --interface active --max-time 5 http://ip-api.com/json); then
        IP=$(echo "$INFO" | jq -r .query)
        COUNTRY=$(echo "$INFO" | jq -r .country)
        echo ":: SUCCESS: Tunnel LIVE"
        echo ":: Config: $SELECTED"
        echo ":: VPN IP: $IP ($COUNTRY)"
      else
        echo ":: ERROR: Tunnel failed"
        exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ awgu ];
}
