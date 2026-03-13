{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs;[

    # System
    wget
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
    sshfs
    tcpdump
    mkcert
    mesa-demos
    waffle
    apitrace
    openssl

    # Desktop
    fuzzel
    mako
    libnotify
    swww
    xremap
    hyprshot
    hyprpicker
    wlsunset
    wl-clipboard
    peazip
    bitwarden-desktop
    qwen-code
    gnome-calculator
    gnome-clocks
    godot

    # Terminal Programs
    foot
    kitty
    alacritty
    btop
    repomix
    ripgrep
    bat
    fd
    fastfetch
    starship
    hyperfine
    lazygit

    # Virtualization
    distrobox

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

    # Web
    ayugram-desktop

    # Themes and Icons
    nwg-look
    adwaita-icon-theme
    
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
