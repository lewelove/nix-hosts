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

# 1. Repomix
echo
gum join --horizontal "$(g ">")" " Repomixing..."
repomix --quiet --include "common/**,home/**" || true
repomix --quiet --include "common/**,lab/**" || true

# 2. Local Git Commit (For your history/Origin)
echo
gum join --horizontal "$(g ">")" " Committing local changes..."
git add .
if ! git diff-index --quiet HEAD --; then
    git commit -m "$MSG"
fi

# 3. RSYNC to Lab (Bit-for-bit replication)
# We assume the remote is lewelove@192.168.1.100:~/nix-hosts
# We use -a (archive), -v (verbose), -z (compress), --delete (wipe extra files)
if git remote | grep -q "^lab$"; then
    LAB_ADDR=$(git remote get-url lab)
    
    # Strip the 'git' specific suffix if you were using .git before
    # or just hardcode it if the remote URL format is weird.
    # Standard format: lewelove@192.168.1.100:~/nix-hosts
    TARGET_ADDR=''${LAB_ADDR%.git} 

    echo
    gum join --horizontal "$(g ">")" " Mirroring to Lab via " "$(y "rsync")" "..."
    
    rsync -avz --delete \
      --exclude ".direnv/" \
      --exclude "result" \
      "${repoPath}/" "$TARGET_ADDR/"
    
    echo
    gum join --horizontal "$(g ">")" " " "$(g "SUCCESS")" " - Lab is now a perfect mirror."
fi

# 4. Push to Origin (GitHub/Gitea backup)
if git remote | grep -q "^origin$"; then
    echo
    gum join --horizontal "$(g ">")" " Pushing to Origin..."
    git push -uq origin main
fi

################################################################
    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
