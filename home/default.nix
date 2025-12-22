{ ... }:

{

  imports = [

    # System
    ./system.nix

    # Home Manager
    ./modules/home-managert.nix

    # Modules
    ./modules/hardware-configuration.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/nvidia.nix
    ./modules/games.nix

    # System Services
    ./services/system/keyd.nix

    # Scripts
    ./scripts/tilde-stow.nix
  ];

}
