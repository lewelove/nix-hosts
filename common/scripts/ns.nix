{ pkgs, identity, hostPath, ... }:

let
  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ git stow repomix coreutils ];
    text = ''
      REPO_DIR="${identity.repoPath}"
      MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"

      # 1. Ensure .config exists so Stow doesn't link the whole directory
      mkdir -p "$HOME/.config"

      # 2. Stow Common Workflow
      if [ -d "$REPO_DIR/common/tilde" ]; then
          echo ":: Stowing Common Workflow..."
          cd "$REPO_DIR/common"
          stow --adopt -t "$HOME" tilde --verbose=1
      fi

      # 3. Stow Host Specifics
      if [ -d "${hostPath}/tilde" ]; then
          echo ":: Stowing Host Specifics..."
          cd "${hostPath}"
          stow --adopt -t "$HOME" tilde --verbose=1
      fi

      # 4. Sync Git Repository
      echo -e "\n:: Syncing Git..."
      cd "$REPO_DIR"
      git add .
      git commit -m "$MSG"
      git push
          
      # 5. Refresh LLM Context
      if command -v repomix &> /dev/null; then
          repomix
      fi
    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
