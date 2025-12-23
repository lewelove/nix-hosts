{ pkgs, username, repoPath, hostPath, ... }:

{
  system.activationScripts.tilde-stow = {
    text = ''
      USER_HOME="/home/${username}"

      # Ensure the base config dir exists so Stow doesn't link the whole folder
      ${pkgs.util-linux}/bin/runuser -u ${username} -- mkdir -p "$USER_HOME/.config"

      # 1. Stow Common (Workflow)
      if [ -d "${repoPath}/common/tilde" ]; then
          echo ":: Stowing Common Workflow..."
          cd "${repoPath}/common"
          ${pkgs.util-linux}/bin/runuser -u ${username} -- \
            ${pkgs.stow}/bin/stow --adopt -t "$USER_HOME" tilde --verbose=1
      fi

      # 2. Stow Host (Identity)
      if [ -d "${hostPath}/tilde" ]; then
          echo ":: Stowing Host Specifics..."
          cd "${hostPath}"
          ${pkgs.util-linux}/bin/runuser -u ${username} -- \
            ${pkgs.stow}/bin/stow --adopt -t "$USER_HOME" tilde --verbose=1
      fi
    '';
    deps = [ "users" ];
  };
}
