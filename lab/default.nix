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
    ./modules/system.nix
    ./modules/user.nix

    ./modules/hardware.nix
    ./modules/hardware-configuration.nix

    ./modules/networking.nix
    ./modules/virtualization.nix

    ./modules/packages.nix
    ./modules/programs.nix

    # Scripts
    ./scripts/tilde-stow.nix
    ./scripts/nrs.nix
    ./scripts/ns.nix
  ];

}
