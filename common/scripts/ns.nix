{ pkgs, identity, hostPath, ... }:

let
  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ git stow repomix coreutils gum ];
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

      mkdir -p "$HOME/.config"

      if [ -d "$REPO_PATH/common/tilde" ]; then
          echo
          gum join --horizontal ":: Stowing " "$(b "$HOSTNAME") " "commons..."
          echo
          cd "$REPO_PATH/common"
          stow --adopt -t "$HOME" tilde --verbose=1
      fi

      if [ -d "${hostPath}/tilde" ]; then
          gum join --horizontal ":: Stowing " "$(b "$HOSTNAME") " "specifics..."
          echo
          cd "${hostPath}"
          stow --adopt -t "$HOME" tilde --verbose=1
      fi

      MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"

      gum join --horizontal ":: Syncing " "$(g "$REPO_PATH...")"
      echo
      cd "$REPO_PATH"
      git add .
      git commit -m "$MSG"
      git push
      echo
          
      if command -v repomix &> /dev/null; then
          gum join --horizontal ":: Repomixing " "$(g "$REPO_PATH...")"
          repomix --quiet
          repomix --quiet --include "common/**,home/**"
          repomix --quiet --include "common/**,lab/**"
      fi
    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
