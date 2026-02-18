{ pkgs, identity, repoPath, hostPath, ... }:

let
  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ git stow repomix coreutils gum rsync openssh ];
    text = ''

################################################################

rb() { gum style --foreground 1 --bold "$*"; }
gb() { gum style --foreground 2 --bold "$*"; }
yb() { gum style --foreground 3 --bold "$*"; }
bb() { gum style --foreground 4 --bold "$*"; }
mb() { gum style --foreground 5 --bold "$*"; }
wb() { gum style --foreground 7 --bold "$*"; }
r() { gum style --foreground 1 "$*"; }
g() { gum style --foreground 2 "$*"; }
y() { gum style --foreground 3 "$*"; }
b() { gum style --foreground 4 "$*"; }
m() { gum style --foreground 5 "$*"; }
w() { gum style --foreground 7 "$*"; }

MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"
cd "${repoPath}"

echo
gum join --horizontal "$(g "> Repomixing...")"
repomix --quiet --include "dotfiles/**,common/**,home/**" || true
repomix --quiet --include "dotfiles/**,common/**,lab/**" || true

echo
gum join --horizontal "$(g "> Committing local changes...")"
git add .
if ! git diff-index --quiet HEAD --; then
    git commit -m "$MSG"
else
    echo ":: No changes to commit locally."
fi

if git remote | grep -q "^lab$"; then
    RAW_ADDR=$(git remote get-url lab)
    TARGET_ADDR=''${RAW_ADDR%.git}
    TARGET_ADDR=''${TARGET_ADDR%/}

    echo
    gum join --horizontal "$(g ">")" " Mirroring to Lab (" "$(y "$TARGET_ADDR")" ")..."
    
    if rsync -azq --delete \
      --exclude ".direnv/" \
      --exclude "result" \
      "${repoPath}/" "$TARGET_ADDR/"; 
    then
        gum join --horizontal "$(g "> SUCCESS")" " - Lab is now a perfect mirror."
    else
        echo
        gum join --horizontal "$(r "> FAILURE")" " - Sync to Lab failed."
        exit 1
    fi
fi

if git remote | grep -q "^origin$"; then
    if
        echo
        gum join --horizontal "$(g ">")" " Pushing to Origin..."
        git push -u origin main
    then
        echo
        gum join --horizontal "$(g "> SUCCESS")" " - Pushed to origin."
    else
        echo
        gum join --horizontal "$(r "> FAILURE")" " - Git Push failed."
    fi
fi

################################################################
    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
