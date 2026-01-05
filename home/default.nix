{ ... }:

{

  imports = [

    # System
    ./system.nix
    ./user.nix

    # Home Manager
    ./hm

    # Modules
    ./modules/boot.nix
    ./modules/environment.nix

    ./modules/hardware-configuration.nix
    ./modules/nvidia.nix

    ./modules/networking.nix
    ./modules/bluetooth.nix
    ./modules/virtualization.nix

    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/games.nix

    # Programs
    ./programs/chromium.nix

    # Web Applications
    ./programs/web-applications/youtube.nix
    ./programs/web-applications/figma.nix

    ./programs/web-applications/qbittorrent.nix
    ./programs/web-applications/jellyfin.nix
    ./programs/web-applications/mympd.nix

    # Services
    # ./services/system/keyd.nix
    ./services/chromium-service.nix
    ./services/mympd.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix
    ../common/scripts/ns.nix
    ../common/scripts/nt.nix
  ];

}
