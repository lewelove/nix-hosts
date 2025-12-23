{ ... }:

{

  imports = [

    # System
    ./system.nix

    # Home Manager
    ./modules/home-manager.nix

    # Modules
    ./modules/disko.nix

    ./modules/boot.nix
    ./modules/user.nix

    ./modules/hardware-configuration.nix

    ./modules/networking.nix
    ./modules/virtualization.nix

    ./modules/packages.nix
    ./modules/programs.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix

  ];

}
