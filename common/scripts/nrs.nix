{ pkgs, identity, ... }:

let
  nrs = pkgs.writeShellApplication {
    name = "nrs";
    runtimeInputs = with pkgs; [ nixos-rebuild coreutils gum ];
    text = ''

      wb() { gum style --foreground 7 --bold "$*"; }
      rb() { gum style --foreground 1 --bold "$*"; }
      gb() { gum style --foreground 2 --bold "$*"; }
      bb() { gum style --foreground 4 --bold "$*"; }
      w() { gum style --foreground 7 "$*"; }
      r() { gum style --foreground 1 "$*"; }
      g() { gum style --foreground 2 "$*"; }
      b() { gum style --foreground 4 "$*"; }

      REPO_PATH="${identity.repoPath}"
      
      TARGET_HOST="''${1:-$(hostname)}"
      TARGET_PATH="$REPO_PATH/$TARGET_HOST"

      if [ ! -d "$TARGET_PATH" ]; then
        echo ":: Error: Host directory $TARGET_PATH does not exist in $REPO_PATH"
        exit 1
      fi

      cd "$REPO_PATH" || exit 1

      echo
      gum join --horizontal ":: Rebuilding NixOS for " "$(b "$TARGET_HOST")" "..."
      echo

      if sudo nixos-rebuild switch --flake "$TARGET_PATH#$TARGET_HOST"; then
          tilde-stow
          gum join --horizontal ":: " "$(gb "SUCCESS ")" "Configuration for " "$(b "$TARGET_HOST ")" "applied."
      else
          echo
          gum join --horizontal ":: " "$(rb "FAILURE ")" "Build failed."
          exit 1
      fi
    '';
  };
in
{
  environment.systemPackages = [ nrs ];
}
