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

    # Desktop
    fuzzel
    quickshell
    hyprpaper
    hyprshot
    wlsunset
    peazip
    bitwarden-desktop

    # Terminal Programs
    foot
    kitty
    neovim
    btop

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
    easyeffects
    
    # Network
    amneziawg-go
    amneziawg-tools

    # Web
    ungoogled-chromium
    librewolf
    ayugram-desktop

    # Themes and Icons
    adwaita-icon-theme
    
    # Flake Inputs
    inputs.zen-browser.packages.x86_64-linux.default

  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.thunar.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.bash.shellAliases = {
    nv = "nvim";
    nrs = "sudo nixos-rebuild switch --flake /home/lewelove/nixos-machines/.#home"; 
  };
}
