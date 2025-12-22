{ ... }:

{
  imports = [

    # System
    ./system.nix

    # Home Manager
    ./modules/home-manager/default.nix

    # Modules
    ./modules/hardware-configuration.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/home-manager.nix
    ./modules/nvidia.nix
    ./modules/games.nix

    # Services
    ./services/mpd.nix
    ./services/swww.nix
    ./services/wlsunset.nix
    ./services/quickshell.nix
    ./services/listenbrainz.nix

    # Scripts
    ./scripts/tilde-stow.nix

  ];
}
