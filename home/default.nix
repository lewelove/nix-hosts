{ ... }:

{

  imports = [

    # System
    ./system.nix
    ./user.nix

    # Modules
    ./modules/boot.nix
    ./modules/environment.nix

    ./modules/hardware-configuration.nix
    ./modules/nvidia.nix

    ./modules/tilde.nix
    ./modules/networking.nix
    ./modules/bluetooth.nix
    ./modules/virtualization.nix

    ./modules/home-manager.nix
    ./modules/theme.nix

    ./modules/packages.nix
    ./modules/games.nix

    # Programs
    ./programs/chromium.nix
    ./programs/hyprland.nix
    ./programs/thunar.nix
    ./programs/system.nix

    # Web Applications
    ./programs/youtube.nix
    ./programs/photopea.nix
    ./programs/figma.nix

    # Local Network Web Applications
    ./programs/qbittorrent.nix
    ./programs/jellyfin.nix
    ./programs/vscode.nix
    ./programs/comfyui.nix
    ./programs/vellum.nix
    ./programs/excalidraw.nix

    # System Services
    # ./services/xremap.nix
    ./services/keyd.nix
    ./services/olivetin.nix
    ./services/open-webui.nix

    # User Services
    ./services/user/mpd.nix
    ./services/user/swww.nix
    # ./services/user/wlsunset.nix
    ./services/user/quickshell.nix
    ./services/user/listenbrainz-mpd-90-no4m.nix
    ./services/user/polkit-agent.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix
    ../common/scripts/ns.nix
    ../common/scripts/nt.nix
    ../common/scripts/sync.nix
    ./scripts/awgr.nix
  ];

}
