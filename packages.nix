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

    # Desktop
    fuzzel
    quickshell
    hyprpaper
    wlsunset
    xfce.thunar

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

    # Themes and Icons
    adwaita-icon-theme
    
    # Flake Inputs
    inputs.zen-browser.packages.x86_64-linux.default

  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.bash.shellAliases = {
    nv = "nvim";
    nrs = "sudo nixos-rebuild switch --flake /home/lewe/nixos-machines/.#home"; 
  };
}
