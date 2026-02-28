{ pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [

    # System
    wget
    stow
    unzip
    gcc
    tree
    killall
    jq
    jaq
    ydotool
    wtype
    wev
    xhost
    pulseaudio
    gnome-disk-utility
    bluez
    blueman
    sshfs
    nfs-utils
    tcpdump
    mkcert

    # Desktop
    fuzzel
    quickshell
    mako
    libnotify
    swww
    xremap
    hyprshot
    hyprpicker
    wlsunset
    wl-clipboard
    polkit_gnome
    peazip
    bitwarden-desktop
    qwen-code
    gnome-calculator
    godot

    # Terminal Programs
    foot
    kitty
    neovim
    btop
    repomix
    yazi
    ripdrag
    ripgrep
    bat
    fd
    fastfetch
    starship
    hyperfine
    lazygit

    # Virtualization
    distrobox
    runc
    crun

    # Media
    mpv
    imv
    mpc
    rmpc
    flac
    flac2all
    mediainfo
    imagemagick
    puddletag
    roomeqwizard
    
    # Network
    amneziawg-go
    amneziawg-tools

    # Web
    ayugram-desktop
    figma-agent

    # Themes and Icons
    nwg-look
    adwaita-icon-theme
    papirus-icon-theme
    dconf
    libsForQt5.qt5ct
    kdePackages.qt6ct
    
    # Nix
    nh
    nvd
    nix-output-monitor

    # Flake Inputs
    inputs.nvibrant.packages.${pkgs.system}.default
    inputs.zen-browser.packages.x86_64-linux.default
    # inputs.photogimp.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

}
