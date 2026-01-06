{ pkgs, identity, repoPath, hostPath, ... }:

let
  nrs = pkgs.writeShellApplication {
    name = "nrs";
    runtimeInputs = with pkgs; [ nh nix-output-monitor nvd coreutils gum ];
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

TARGET_HOST="''${1:-$(hostname)}"

if [ ! -d "${hostPath}" ]; then
  echo "$(g ">")" " Error: Host directory ${hostPath} does not exist in ${repoPath}"
  exit 1
fi

cd "${repoPath}" || exit 1

git add .

echo
gum join --horizontal "$(g ">")" " Rebuilding NixOS for " "$(b "$TARGET_HOST")" "..."
echo

export NH_FLAKE="${hostPath}"

if
    NH_NOM=1 nh os switch "${hostPath}" --hostname "$TARGET_HOST"
then
    tilde-stow
    echo
    gum join --horizontal "$(g ">")" " " "$(g "SUCCESS ")" "Configuration for " "$(b "$TARGET_HOST")" " applied."
else
    echo
    gum join --horizontal "$(b ">")" " " "$(r "FAILURE ")" "Build failed."
    exit 1
fi

################################################################

    '';
  };
in
{
  environment.systemPackages = [ nrs ];
}
