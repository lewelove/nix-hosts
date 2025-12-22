{ ... }:

{

  imports = [

    # System
    ./system.nix

    # Home Manager
    ./modules/home-manager.nix

    # Modules
    ./modules/hardware-configuration.nix
    ./modules/packages.nix
    ./modules/bluetooth.nix
    ./modules/programs.nix
    ./modules/nvidia.nix
    ./modules/games.nix
    ./modules/virtualization.nix

    # System Services
    # ./services/system/keyd.nix
    ./services/mympd.nix

    # Scripts
    ./scripts/tilde-stow.nix
  ];

}
