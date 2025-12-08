source /usr/share/cachyos-fish-config/cachyos-config.fish

if status is-interactive

  fish_vi_key_bindings
  fish_add_path /usr/lib/xfce-polkit

# editor configs
  set edit nvim
  set terminal foot

# configuration files
  set shell_config ~/.config/fish/config.fish
  set terminal_config ~/.config/foot/foot.ini

  set editor_config ~/.config/nvim/init.lua

  set wm_config ~/.config/hypr/hyprland.conf
  set bar_config ~/.config/waybar/config.jsonc
  set barst_config ~/.config/waybar/style.css

  set fetch_config ~/.config/fastfetch/config.jsonc
  set img_config ~/.config/imv/config
	set vid_config ~/.config/mpv/mpv.conf

# shell aliases
  # edits
  function editsh;     $edit $shell_config;     end
  function editterm;   $edit $terminal_config;  end
  function editedit;   $edit $editor_config;    end

  function editwm;     $edit $wm_config;        end
  function editbar;    $edit $bar_config;       end
  function editbarst;  $edit $barst_config;     end

  function editfetch;  $edit $fetch_config;     end
  function editimg;    $edit $img_config;       end
  function editvid;    $edit $vid_config;       end

  alias nv "nvim"
  alias nvnotes "NVIM_APPNAME=nvim-notes nvim"
  alias docker "sudo docker"
  alias x+ "chmod +x"
  alias clients "hyprctl clients"
  alias ipcheck "curl ip-api.com/line"
  alias uvr "env PYTHONDONTWRITEBYTECODE=1 uv run"

  # pacman
  alias pacr "sudo pacman -Rs"
  alias pacs "sudo pacman -S"
  alias pacq "pacman -Q | grep"

  # amnezia-wg
  alias awgu "sudo awg-quick up"
  alias awgd "sudo awg-quick down"
  alias awgdd "sudo killall amneziawg-go"
  alias awgr "sudo killall amneziawg-go & sudo awg-quick up (find $HOME/VPN/awg/*.conf | shuf -n 1)"

  # open vpn
  alias ovpndd "sudo killall openvpn"
  alias ovpnr "sudo killall openvpn & sudo openvpn --config (find $HOME/VPN/ovpn/*.ovpn | shuf -n 1)"

end

# pnpm
set -gx PNPM_HOME "/home/lewelove/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
