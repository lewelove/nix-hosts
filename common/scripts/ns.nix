{ pkgs, identity, repoPath, hostPath, ... }:

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

      tilde-stow

      MSG="''${1:-$(date -u +'%Y-%m-%d %H:%M UTC')}"

      echo
      cd "${repoPath}"
      git add .
      git commit -m "$MSG"

      if git remote | grep -q "^lab$"; then
          gum join --horizontal ":: Syncing to " "$(b "lab")" " via LAN..."
          git push lab main
          echo
      fi

      gum join --horizontal ":: Syncing to " "$(g "origin")" "..."
      git push -u origin main
      echo
          
      gum join --horizontal ":: Repomixing " "$(g "${repoPath}...")"
      repomix --quiet
      repomix --quiet --include "common/**,home/**"
      repomix --quiet --include "common/**,lab/**"
    '';
  };
in
{
  environment.systemPackages = [ ns ];
}
