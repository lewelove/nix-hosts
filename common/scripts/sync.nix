{ pkgs, ... }:

let
  sync = pkgs.writeShellApplication {
    name = "sync";
    runtimeInputs = with pkgs; [ git coreutils gum repomix ];
    text = ''
      ################################################################
      # Style Helpers
      ################################################################
      r() { gum style --foreground 1 "$*"; }
      g() { gum style --foreground 2 "$*"; }
      y() { gum style --foreground 3 "$*"; }
      b() { gum style --foreground 4 "$*"; }
      m() { gum style --foreground 5 "$*"; }

      # 1. Check if we are in a git repo
      if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo
          gum join --horizontal "$(r "[!] ")" "Error: Not in a git repository."
          exit 1
      fi

      GIT_ROOT=$(git rev-parse --show-toplevel)
      cd "$GIT_ROOT"

      # 2. Get Branch info
      BRANCH=$(git branch --show-current)
      if [ -z "$BRANCH" ]; then
          # Fallback for detached HEAD or fresh repos
          BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "head")
      fi

      MSG="''${1:-$(date -u +'%Y-%m-%d at %H:%M UTC')}"

      echo
      gum join --horizontal "$(m "[>] ")" "Syncing: " "$(y "$GIT_ROOT")"
      gum join --horizontal "$(m "[>] ")" "Branch:  " "$(b "$BRANCH")"
      echo

      # 3. Add and Commit
      gum join --horizontal "$(m "[>] ")" "Staging changes..."
      git add .

      if ! git diff-index --quiet HEAD --; then
          gum join --horizontal "$(g "[+] ")" "Committing: " "$(w "$MSG")"
          git commit -m "$MSG"
      else
          gum join --horizontal "$(y "[~] ")" "No changes to commit."
      fi

      # 4. Push logic with remote check
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
              # We don't exit here so repomix can still run
          fi
      fi

      # 5. Local Housekeeping
      echo
      gum join --horizontal "$(m "[>] ")" "Running Repomix..."
      repomix --quiet || true
      
      gum join --horizontal "$(g "[+] ")" "Sync Complete."
      echo
      ################################################################
    '';
  };
in
{
  environment.systemPackages = [ sync ];
}
