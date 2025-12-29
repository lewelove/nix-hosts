{ pkgs, ... }:

let
  awgr = pkgs.writeShellApplication {
    name = "awgr";
    runtimeInputs = with pkgs; [ systemd gum coreutils ];
    text = ''
      if [ ! -L "/etc/amneziawg/active.conf" ]; then
        echo "Error: No active configuration linked. Use 'awgu' first."
        exit 1
      fi

      CURRENT=$(readlink /etc/amneziawg/active.conf)
      echo ":: Reloading $(basename "$CURRENT")..."
      
      sudo systemctl restart awg-vpn
      
      echo ":: Current IP:"
      curl -s ip-api.com/line | gum style --foreground 2
    '';
  };
in
{
  environment.systemPackages = [ awgr ];
}
