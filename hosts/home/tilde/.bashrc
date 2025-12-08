# Programs
alias nv=nvim
alias nvnotes='NVIM_APPNAME=nvim-notes nvim'

alias clients='hyprctl clients'
alias x+='chmod +x'

alias docker='sudo docker'
alias uvr='env PYTHONDONTWRITEBYTECODE=1 uv run'

# Networking
alias awgd='sudo killall amneziawg-go'
alias awgr='sudo killall amneziawg-go & sudo awg-quick up $(find $HOME/VPN/awg/*.conf | shuf -n 1)'

alias ipcheck='curl ip-api.com/line'
