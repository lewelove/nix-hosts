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
    btop
    wol
    tcpdump
    ether-wake

    # Terminal Programs
    neovim

    # Virtualization
    distrobox
    runc
    crun

    # Rust Utils
    ripgrep
    bat
    fd
    fzf

    # Media
    mpc
    rmpc
    
  ];

}
