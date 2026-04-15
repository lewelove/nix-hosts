set -g fish_greeting

if status is-interactive

  starship init fish | source

  set -g fish_color_command green

  function starship_newline --on-event fish_prompt
      if set -q _starship_rendered
          echo ""
      end
      set -g _starship_rendered 1
  end

  fish_add_path "$HOME/.commands"
  fish_add_path "$HOME/.scripts"

  alias clr="set -e _starship_rendered; clear"
  alias clear="set -e _starship_rendered; command clear"

  alias x+="chmod +x"
  alias nv="nvim"
  alias lg="lazygit"
  alias gs="git status"

  alias clients="hyprctl clients | rg -A 3 'class'"
  alias awgd="sudo killall amneziawg-go"
  alias ipcheck="curl ip-api.com"
  alias scus="systemctl --user status"
  alias scur="systemctl --user restart"
  alias scs="systemctl status"
  alias scr="systemctl restart"
  alias jc="journalctl -fu"
  alias jcu="journalctl --user -fu"
  alias sync="git-sync-bin"

  # album curation utils
  alias discid="/home/lewelove/dev/album_curation/discid/.build/bin/discid"
  alias albumw="/home/lewelove/dev/album_curation/album_write/.build/bin/album_write"
  alias albumspl="/home/lewelove/dev/album_curation/album_split/.build/bin/album_split"
  alias mbid="/home/lewelove/dev/album_curation/mbid/.build/bin/mbid"

  function distrobox
      if contains $argv[1] create rm stop assemble
          systemd-run --user --scope --unit=distrobox-setup distrobox $argv
      else
          command distrobox $argv
      end
  end

end
