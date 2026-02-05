{ pkgs, ... }:

let
  awgr = pkgs.writeShellApplication {
    name = "awgr";
    runtimeInputs = with pkgs; [ 
      coreutils 
      findutils 
      gum 
      curl 
      jq 
      amneziawg-tools 
      psmisc
    ];
    text = ''
      if [ "$EUID" -ne 0 ]; then
        exec sudo "$0" "$@"
      fi

      SOURCE_DIR="/home/lewelove/VPN/awg"
      TARGET_DIR="/etc/amneziawg"
      TARGET_CONF="$TARGET_DIR/active.conf"

      SELECTED=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.conf" -printf "%f\n" | gum choose --header "Select VPN Endpoint")

      if [ -z "$SELECTED" ]; then
        exit 0
      fi

      echo ":: Switching to $SELECTED..."

      killall amneziawg-go 2>/dev/null || true
      
      mkdir -p "$TARGET_DIR"
      ln -sf "$SOURCE_DIR/$SELECTED" "$TARGET_CONF"

      awg-quick up "$TARGET_CONF" 2>/dev/null || true

      if INFO=$(curl -s --interface active --max-time 5 http://ip-api.com/json); then
        IP=$(echo "$INFO" | jq -r .query)
        COUNTRY=$(echo "$INFO" | jq -r .country)
        echo ""
        gum join --horizontal ":: " "$(gum style --foreground 2 --bold "SUCCESS")" " - Tunnel LIVE"
        echo ":: Config:  $SELECTED"
        echo ":: VPN IP:  $IP ($COUNTRY)"
      else
        echo ""
        gum join --horizontal ":: " "$(gum style --foreground 3 --bold "WARNING")" " - Tunnel UP, check failed"
      fi
    '';
  };
in
{
  environment.systemPackages = [ awgr ];
}
