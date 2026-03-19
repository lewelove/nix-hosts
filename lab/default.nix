{ inputs, lib, ... }:

{

  imports = [

    # System
    ./system.nix
    ./user.nix

    # Network
    ./network/core.nix
    ./network/inbound.nix
    ./network/openssh.nix
    ./network/duckdns.nix
    ./network/reverse-proxy.nix
    ./network/fail2ban.nix
    ./network/auth.nix

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

    # Programs
    (lib.pipe inputs.import-tree[
      (i: i.filterNot (path: lib.hasInfix "/disabled/" path))
      (i: i ./programs)
    ])

    # Services
    (lib.pipe inputs.import-tree [
      (i: i.filterNot (path: lib.hasInfix "/disabled/" path))
      (i: i ./services)
    ])

    # Scripts
    ../common/scripts/nrs.nix
    ./scripts/awgu.nix
    ./scripts/awgd.nix
    ./scripts/awgr.nix

    # Commercial
    ./commercial/telegram-bot.nix

  ];

}
