# export PATH="$HOME/.commands:$HOME/.scripts:$PATH"

# Programs
alias nv=nvim
alias nvn='NVIM_APPNAME=nvim-notes nvim'

alias clients='hyprctl clients'
alias x+='chmod +x'

# Networking
alias awgd='sudo killall amneziawg-go'
alias awgr='sudo killall amneziawg-go & sudo awg-quick up $(find $HOME/VPN/awg/*.conf | shuf -n 1)'

alias ipcheck='curl ip-api.com'

alias sc='systemctl'
alias status='systemctl status'
alias scu='systemctl --user'
alias jc='journalctl -fu'
alias jcu='journalctl --user -fu'

distrobox() {
  if [[ "$1" == "create" || "$1" == "rm" || "$1" == "stop" || "$1" == "assemble" ]]; then
    systemd-run --user --scope --unit=distrobox-setup distrobox "$@"
  else
    command distrobox "$@"
  fi
}

gitsync() {
    local branch
    branch=$(git branch --show-current)
    
    if [ -z "$branch" ]; then
        echo "Error: Not in a git repository or no branch found."
        return 1
    fi

    if [ -z "$1" ]; then
        msg=$(date -u +"%Y-%m-%d at %H:%M UTC")
    else
        msg="$1"
    fi

    git add .
    git commit -m "$msg"
    git push -u origin "$branch"
    
    repomix --quiet
}
