{ pkgs, config, ... }:

let
  user = "lewelove";
  # Ensure this matches your folder name
  repoPath = "/home/${user}/nixos-machines"; 
  targetHost = config.networking.hostName; 
in
{
  system.activationScripts.zen-stow = {
    text = ''
      # Paths
      USER_HOME="/home/${user}"
      MACHINE_DIR="${repoPath}/home"
      DOTFILES_DIR="$MACHINE_DIR/tilde"

      echo "------------------------------------------------"
      echo "⚡ Stowing dotfiles from: $DOTFILES_DIR"

      if [ -d "$DOTFILES_DIR" ]; then
          # --adopt tells Stow: "If you find a file/link that conflicts, 
          # assume it belongs to us and update the link to point here."
          ${pkgs.util-linux}/bin/runuser -u ${user} -- \
            ${pkgs.stow}/bin/stow --adopt -d "$MACHINE_DIR" -t "$USER_HOME" -R "tilde" --verbose=1
      else
          echo "⚠ No 'tilde' directory found at $DOTFILES_DIR."
      fi

      echo "------------------------------------------------"
    '';
    deps = [ "users" ];
  };
}
