{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    stow
    unzip
    gcc
    tree
    killall

    # Rust Utils
    ripgrep
    bat
    fd

    kitty
    foot
    librewolf
    fuzzel
    mpv
    imv
    xfce.thunar
    quickshell
    hyprpaper
    adwaita-icon-theme
    easyeffects
    
    amneziawg-go
    amneziawg-tools

    neovim
    repomix
    
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
