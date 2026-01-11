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
    ./modules/disko.nix

    ./modules/networking.nix
    ./modules/bluetooth.nix

    ./modules/home-manager.nix
    ./modules/theme.nix

    ./modules/packages.nix

    # Programs
    ./programs/chromium.nix
    ./programs/sway.nix
    ./programs/thunar.nix
    ./programs/system.nix

    # Web Applications
    ./programs/web-applications/youtube.nix
    ./programs/web-applications/figma.nix

    # Local Web Applications
    ./programs/web-applications/qbittorrent.nix
    ./programs/web-applications/jellyfin.nix
    ./programs/web-applications/mympd.nix

    # System Services
    # ./services/xremap.nix
    # ./services/mympd.nix

    # User Services
    # ./services/user/mpd.nix
    ./services/user/chromium-service.nix
    ./services/user/swww.nix
    ./services/user/wlsunset.nix
    # ./services/user/listenbrainz-mpd-90-no4m.nix
    ./services/user/polkit-agent.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix
    ../common/scripts/ns.nix
    ../common/scripts/nt.nix
  ];

}
