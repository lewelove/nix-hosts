{ pkgs, identity, hostPath, ... }:

let
  nrs = pkgs.writeShellApplication {
    name = "nrs";
    runtimeInputs = with pkgs; [ git nixos-rebuild repomix ];
    text = ''
      REPO_DIR="${identity.repoPath}"
      HOST_PATH="${hostPath}"
      HOSTNAME="${identity.hostname}"

      cd "$REPO_DIR" || exit 1

      echo
      echo ":: Rebuilding NixOS for $HOSTNAME..."
      echo

      if sudo nixos-rebuild switch --flake "$HOST_PATH#$HOSTNAME"; then
          echo
          echo ":: Rebuild OK."
          echo
      else
          echo
          echo ":: Rebuild FAILED. Skipping sync."
          echo
          exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ nrs ];
}
