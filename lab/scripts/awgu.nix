{ pkgs, ... }:

let
  awgu = pkgs.writeShellApplication {
    name = "awgu";
    runtimeInputs = with pkgs; [ coreutils gum systemd ];
    text = ''
      CONF_DIR="/etc/amneziawg"
      
      if [ ! -d "$CONF_DIR" ]; then
        echo "Error: $CONF_DIR does not exist."
        exit 1
      fi

      # Move to directory to use globs safely
      cd "$CONF_DIR"

      # Use a Bash array to find .conf files safely
      # This handles spaces and special characters correctly
      configs=()
      for f in *.conf; do
          # Skip the active.conf symlink and ensure file exists
          if [[ "$f" != "active.conf" && -f "$f" ]]; then
              configs+=("$f")
          fi
      done

      if [ "''${#configs[@]}" -eq 0 ]; then
        echo "No .conf files found in $CONF_DIR"
        exit 1
      fi

      # Pipe the array to gum
      SELECTED=$(printf "%s\n" "''${configs[@]}" | gum choose --header "Select VPN Config")

      if [ -z "$SELECTED" ]; then
        exit 0
      fi

      echo ":: Linking $SELECTED to active.conf"
      sudo ln -sf "$CONF_DIR/$SELECTED" "$CONF_DIR/active.conf"
      
      echo ":: Starting VPN..."
      sudo systemctl restart awg-vpn
      
      echo ":: Status:"
      curl -s ip-api.com/line | gum style --foreground 2
    '';
  };
in
{
  environment.systemPackages = [ awgu ];
}
