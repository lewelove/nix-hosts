{ ... }:

{
  imports = [

    # System
    ./system.nix

    # Modules
    ./modules/hardware.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/home-manager.nix
    ./modules/nvidia.nix
    ./modules/games.nix

    # Scripts
    ./scripts/tilde-stow.nix

  ];
}
