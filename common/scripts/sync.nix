{ pkgs, ... }:

let
  git-sync-bin = pkgs.writeShellApplication {
    name = "git-sync-bin"; # Internal name to avoid PATH collisions
    runtimeInputs = with pkgs; [ git coreutils gum repomix bash ];
    text = ''
      r() { gum style --foreground 1 "$*"; }
      g() { gum style --foreground 2 "$*"; }
      y() { gum style --foreground 3 "$*"; }
      b() { gum style --foreground 4 "$*"; }
      m() { gum style --foreground 5 "$*"; }
      w() { gum style --foreground 7 "$*"; }

      if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          gum join --horizontal "$(r "[!] ")" "Error: Not in a git repository."
          exit 1
      fi

      GIT_ROOT=$(git rev-parse --show-toplevel)
      cd "$GIT_ROOT"

      # Check for custom sync script
      if [ -f "$GIT_ROOT/.sync.sh" ]; then
          echo
          gum join --horizontal "$(m "[>] ")" "Custom sync script found: " "$(y ".sync.sh")"
          echo
          chmod +x "$GIT_ROOT/.sync.sh"
          bash "$GIT_ROOT/.sync.sh" "$@"
      fi

      BRANCH=$(git branch --show-current 2>/dev/null || echo "")
      if [ -z "$BRANCH" ]; then
          BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
      fi

      MSG="''${1:-$(date -u +'%Y-%m-%d at %H:%M UTC')}"

      echo
      gum join --horizontal "$(m "[>] ")" "Syncing " "$(y "$GIT_ROOT") to " "$(b "origin/$BRANCH")"
      echo

      gum join --horizontal "$(m "[>] ")" "Staging changes..."
      git add .

      if ! git diff-index --quiet HEAD --; then
          gum join --horizontal "$(g "[+] ")" "Committing: " "$(w "$MSG")"
          git commit -m "$MSG"
      else
          gum join --horizontal "$(y "[~] ")" "No changes to commit."
      fi

      if ! git remote | grep -q "^origin$"; then
          echo
          gum join --horizontal "$(y "[!] ")" "No " "$(b "origin")" " remote found. Skipping push."
      else
          echo
          gum join --horizontal "$(m "[>] ")" "Pushing to " "$(b "origin/$BRANCH")" "..."
          if git push -u origin "$BRANCH"; then
              gum join --horizontal "$(g "[+] ")" "Push successful."
          else
              gum join --horizontal "$(r "[!] ")" "Push failed."
          fi
      fi

      echo
      gum join --horizontal "$(m "[>] ")" "Running Repomix..."
      repomix --quiet || true
      echo

      gum join --horizontal "$(g "[+] ")" "Sync Complete."
    '';
  };
in
{
  environment.systemPackages = [ git-sync-bin ];
}
