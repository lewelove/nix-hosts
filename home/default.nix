{ inputs, lib, ... }:

{

  imports = [

    # System
    ./system.nix
    ./user.nix

    # Modules
    ./modules/boot.nix
    ./modules/environment.nix

    ./modules/hardware-configuration.nix
    ./modules/nvidia.nix

    ./modules/tilde.nix
    ./modules/networking.nix
    ./modules/bluetooth.nix
    ./modules/virtualization.nix

    ./modules/home-manager.nix
    ./modules/theme.nix

    ./modules/packages.nix
    ./modules/games.nix

    # Programs
    (lib.pipe inputs.import-tree[
      (i: i.filterNot (path: lib.hasInfix "/disabled/" path))
      (i: i ./programs)
    ])

    # System Services
    # ./services/xremap.nix
    ./services/keyd.nix
    ./services/olivetin.nix
    ./services/open-webui.nix

    # User Services
    # ./services/user/wlsunset.nix
    ./services/user/polkit-agent.nix

    # Scripts
    ../common/scripts/nrs.nix
    ../common/scripts/ns.nix
    ../common/scripts/nt.nix
    ../common/scripts/sync.nix
    ./scripts/awgr.nix
  ];

}
