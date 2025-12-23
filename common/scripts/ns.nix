{ pkgs, identity, hostPath, ... }:

let
  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ git stow repomix coreutils gum ];
    text = ''

      b() { gum style --foreground 4 --bold "$*"; }
      g() { gum style --foreground 2 --bold "$*"; }
      c() { gum style --foreground 6 "$*"; }

      REPO_DIR="${identity.repoPath}"
      MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"

      # 1. Ensure .config exists so Stow doesn't link the whole directory
      mkdir -p "$HOME/.config"

      # 2. Stow Common Workflow
      if [ -d "$REPO_DIR/common/tilde" ]; then
          echo
          gum join --horizontal "::" "$(b "Stowing Common Workflow...")"
          echo
          cd "$REPO_DIR/common"
          stow --adopt -t "$HOME" tilde --verbose=1
      fi

      # 3. Stow Host Specifics
      if [ -d "${hostPath}/tilde" ]; then
          gum join --horizontal ":: " "$(b "Stowing Host Specifics...")"
          echo
          cd "${hostPath}"
          stow --adopt -t "$HOME" tilde --verbose=1
      fi

      # 4. Sync Git Repository
      gum join --horizontal ":: " "$(g "Syncing Git...")"
      echo
      cd "$REPO_DIR"
      git add .
      git commit -m "$MSG"
      git push
      echo
          
      # 5. Refresh LLM Context
      if command -v repomix &> /dev/null; then
          gum join --horizontal ":: " "$(g "Repomixing $REPO_DIR...")"
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
