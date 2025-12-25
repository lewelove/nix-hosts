{ ... }:

{

  imports = [

    # System
    ./system.nix

    # Network
    ./network

    # Home Manager
    ./modules/home-manager.nix

    # Modules
    ./modules/disko.nix

    ./modules/boot.nix
    ./modules/user.nix

    ./modules/hardware-configuration.nix

    ./modules/virtualization.nix

    ./modules/packages.nix
    ./modules/programs.nix

    # Services
    # ./services/tailscale.nix
    ./services/transmission.nix
    ./services/jellyfin.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix
    ./scripts/awgu.nix
    ./scripts/awgd.nix
    ./scripts/awgr.nix

  ];

}
