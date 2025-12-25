{ pkgs, ... }:

let
  awgu = pkgs.writeShellApplication {
    name = "awgu";
    runtimeInputs = with pkgs; [ coreutils systemd jq curl ];
    text = ''
      SOURCE_DIR="/etc/amneziawg/configs"
      ACTIVE_LINK="/etc/amneziawg/active.conf"
      SELECTED="''${1:-}"

      if [ -z "$SELECTED" ]; then
        echo ":: Error: No config specified."
        exit 1
      fi

      if [ ! -f "$SOURCE_DIR/$SELECTED" ]; then
        echo ":: Error: Config $SELECTED not found."
        exit 1
      fi

      sudo ln -sf "$SOURCE_DIR/$SELECTED" "$ACTIVE_LINK"
      sudo systemctl restart awg-vpn
      
      # Wait a moment for the handshake
      sleep 3

      # Force the check through the VPN interface to verify it's working
      if INFO=$(curl -s --interface active http://ip-api.com/json); then
        IP=$(echo "$INFO" | jq -r .query)
        COUNTRY=$(echo "$INFO" | jq -r .country)
        CITY=$(echo "$INFO" | jq -r .city)
        echo ":: SUCCESS: Tunnel is LIVE"
        echo ":: VPN IP: $IP ($CITY, $COUNTRY)"
      else
        echo ":: ERROR: Tunnel is UP but NOT passing traffic!"
        exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ awgu ];
}
