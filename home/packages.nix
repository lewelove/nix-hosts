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

    # Desktop
    fuzzel
    quickshell
    hyprpaper
    hyprshot
    hyprpicker
    wlsunset
    wl-clipboard
    peazip
    bitwarden-desktop

    # Terminal Programs
    foot
    kitty
    neovim
    btop

    # Virtualization
    distrobox

    # CLI Programs
    repomix

    # TUI Programs
    tealdeer
    wikiman

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
    
    # Network
    amneziawg-go
    amneziawg-tools

    # Web
    ungoogled-chromium
    librewolf
    ayugram-desktop

    # Themes and Icons
    nwg-look
    adw-gtk3
    adwaita-icon-theme
    papirus-icon-theme
    dconf
    nwg-look
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.breeze-gtk
    
    # Flake Inputs
    inputs.zen-browser.packages.x86_64-linux.default

  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.thunar.enable = true;

  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.bash.shellAliases = {
    nv = "nvim";
    nrs = "sudo nixos-rebuild switch --flake /home/lewelove/nixos-machines/.#home"; 
  };
}
