{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [

    # System
    git
    wget
    stow
    unzip
    gcc
    tree
    killall
    jq
    ydotool
    wtype
    wev
    xorg.xhost
    pulseaudio
    gnome-disk-utility
    bluez
    blueman

    # Desktop
    fuzzel
    bemenu
    quickshell
    mako
    libnotify
    swww
    hyprshot
    hyprpicker
    wlsunset
    wl-clipboard
    peazip
    bitwarden-desktop
    qwen-code

    # Terminal Programs
    foot
    kitty
    neovim
    btop

    # Virtualization
    distrobox
    runc
    crun

    # CLI Programs
    repomix

    # Rust Utils
    ripgrep
    bat
    fd
    fzf

    # Media
    mpv
    imv
    mpc
    rmpc
    easyeffects
    flac
    mediainfo
    qbittorrent
    
    # Network
    amneziawg-go
    amneziawg-tools

    # Web
    ungoogled-chromium
    librewolf
    ayugram-desktop

    # Themes and Icons
    nwg-look
    adwaita-icon-theme
    papirus-icon-theme
    dconf
    libsForQt5.qt5ct
    kdePackages.qt6ct
    
    # Flake Inputs
    inputs.zen-browser.packages.x86_64-linux.default
    inputs.photogimp.packages.${pkgs.system}.default

  ];

}
