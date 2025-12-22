{ ... }:

{

  imports = [

    # System
    ./system.nix

    # Home Manager
    ./modules/home-manager.nix

    # Modules
    ./modules/boot.nix
    ./modules/system.nix
    ./modules/environment.nix
    ./modules/user.nix

    ./modules/hardware.nix
    ./modules/nvidia.nix

    ./modules/networking.nix
    ./modules/bluetooth.nix
    ./modules/virtualization.nix

    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/games.nix

    # System Services
    # ./services/system/keyd.nix
    ./services/mympd.nix

    # Scripts
    ./scripts/tilde-stow.nix
    ./scripts/nrs.nix
    ./scripts/ns.nix
  ];

}
