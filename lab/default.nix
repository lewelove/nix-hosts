{ ... }:

{

  imports = [

    # System
    ./system.nix
    ./user.nix

    # Network
    ./network/core.nix
    ./network/inbound.nix
    ./network/openssh.nix
    # ./network/amneziawg.nix

    ./network/routing-isp.nix
    # ./network/tailscale.nix

    # Home Manager
    ./modules/home-manager.nix

    # Modules
    ./modules/hardware-configuration.nix
    ./modules/disko.nix

    ./modules/packages.nix
    ./modules/programs.nix

    ./modules/virtualization.nix

    # Services
    # ./services/transmission.nix
    # ./services/olivetin.nix
    ./services/nfs.nix
    ./services/jellyfin.nix
    ./services/qbittorrent.nix
    # ./services/openclaw.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix
    ./scripts/awgu.nix
    ./scripts/awgd.nix
    ./scripts/awgr.nix

  ];

}
