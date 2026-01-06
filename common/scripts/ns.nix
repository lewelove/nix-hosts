{ pkgs, identity, repoPath, hostPath, ... }:

let
  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ git stow repomix coreutils gum ];
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

# tilde-stow

MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"

cd "${repoPath}"

echo
gum join --horizontal "$(g ">")" " Repomixing " "$(g "${repoPath}...")"
repomix --quiet --include "common/**,home/**"
repomix --quiet --include "common/**,lab/**"
# repomix --quiet --include "common/**,note/**"
echo

gum join --horizontal "$(g ">")" " Adding with message " "$(p "$MSG")" "..."
echo
git add .
git commit -m "$MSG"
echo

if git remote | grep -q "^lab$"; then
    gum join --horizontal "$(g ">")" " Syncing to " "$(b "lab")" " via LAN..."
    echo
    git push lab main
    echo
fi

gum join --horizontal "$(g ">")" " Syncing to " "$(g "origin")" "..."
echo
git push -u origin main
    
################################################################

    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
