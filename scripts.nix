{ pkgs, config, ... }:

let
  user = "lewelove";
  nixosMachinesDir = "/home/${user}/nixos-machines";
in
{
  system.activationScripts.zen-tildes = {
    text = ''
      # 1. Variables
      TARGET_HOST="${config.networking.hostName}"
      USER_HOME="/home/${user}"
      ROOT_DIR="${nixosMachinesDir}"
      HOST_DIR="${nixosMachinesDir}/hosts/$TARGET_HOST"

      # 2. Stow Function
      # Usage: run_stow <parent_dir> <package_name>
      run_stow() {
        PARENT_DIR=$1
        PACKAGE_NAME=$2
        
        if [ -d "$PARENT_DIR/$PACKAGE_NAME" ]; then
          echo "Stowing $PACKAGE_NAME from $PARENT_DIR..."
          ${pkgs.util-linux}/bin/runuser -u ${user} -- \
            ${pkgs.stow}/bin/stow -d "$PARENT_DIR" -t "$USER_HOME" -R "$PACKAGE_NAME" --verbose=1
        fi
      }

      echo "------------------------------------------------"
      echo "Synchronizing Tildes..."

      # 3. Apply Root Common Tilde
      # Looks for ~/nixos-machines/tilde-common
      run_stow "$ROOT_DIR" "tilde-common"

      # 4. Apply Host Specific Tilde
      # Looks for ~/nixos-machines/hosts/home/tilde
      run_stow "$HOST_DIR" "tilde"

      echo "Done."
      echo "------------------------------------------------"
    '';
    deps = [ "users" ];
  };
}
