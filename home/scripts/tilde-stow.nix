{ pkgs, username, repoPath, ... }:

{
  system.activationScripts.tilde-stow = {
    text = ''
      USER_HOME="/home/${username}"

      if [ -d "${repoPath}/tilde" ]; then
          echo
          echo ":: Stowing Dotfiles from ${repoPath}/tilde..."

          ${pkgs.util-linux}/bin/runuser -u ${username} -- mkdir -p "$USER_HOME/.config"
          ${pkgs.util-linux}/bin/runuser -u ${username} -- mkdir -p "$USER_HOME/.local/bin"
          ${pkgs.util-linux}/bin/runuser -u ${username} -- mkdir -p "$USER_HOME/.local/share/applications"

          ${pkgs.util-linux}/bin/runuser -u ${username} -- \
            ${pkgs.stow}/bin/stow --adopt -d "${repoPath}" -t "$USER_HOME" tilde --verbose=1
      fi
    '';
    deps = [ "users" ];
  };
}
