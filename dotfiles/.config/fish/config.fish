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

  # --- Basic Aliases ---
  alias clr="clear"
  alias x+="chmod +x"
  alias nv="nvim"
  alias nvn="NVIM_APPNAME=nvim-notes nvim"
  alias clients="hyprctl clients | rg -A 3 'class'"
  alias awgd="sudo killall amneziawg-go"
  alias ipcheck="curl ip-api.com"
  alias scus="systemctl --user status"
  alias scur="systemctl --user restart"
  alias jc="journalctl -fu"
  alias jcu="journalctl --user -fu"

  # Distrobox wrapper
  function distrobox
      if contains $argv[1] create rm stop assemble
          systemd-run --user --scope --unit=distrobox-setup distrobox $argv
      else
          command distrobox $argv
      end
  end

end
