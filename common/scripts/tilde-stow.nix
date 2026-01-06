{ pkgs, identity, repoPath, hostPath, ... }:

let
  tilde-stow = pkgs.writeShellApplication {
    name = "tilde-stow";
    runtimeInputs = with pkgs; [ stow coreutils gum ];
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

mkdir -p "$HOME/.config"

echo

if [ -d "${repoPath}/common/tilde" ]; then
    gum join --horizontal "$(g ">")" " Stowing " "$(b "$HOSTNAME") " "commons..."
    cd "${repoPath}/common"
    stow --adopt -t "$HOME" tilde --verbose=1
fi

if [ -d "${hostPath}/tilde" ]; then
    gum join --horizontal "$(g ">")" " Stowing " "$(b "$HOSTNAME") " "specifics..."
    cd "${hostPath}"
    stow --adopt -t "$HOME" tilde --verbose=1
fi

echo

################################################################

    '';
  };
in
{
  environment.systemPackages = [ tilde-stow ];
}
