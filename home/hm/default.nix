{ config, pkgs, inputs, username, ... }:

{

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username; };
    backupFileExtension = "backup"; 
    users.${username} = { config, ... }: {
      home.stateVersion = "25.05";

      imports = [
        
        inputs.xremap.homeManagerModules.default

        ./theme.nix

        ./services/mpd.nix
        ./services/swww.nix
        ./services/wlsunset.nix
        ./services/quickshell.nix
        ./services/listenbrainz-mpd-90-no4m.nix
        ./services/xremap.nix
        ./services/polkit-agent.nix
      ];

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        download = "/run/media/${username}/1000xhome/downloads";
      };

      home.file = {
        "Downloads/1000xhome".source = config.lib.file.mkOutOfStoreSymlink "/run/media/${username}/1000xhome/downloads";
        "Downloads/x2000".source    = config.lib.file.mkOutOfStoreSymlink "/run/media/${username}/x2000/downloads";
        "Downloads/1000xlab".source = config.lib.file.mkOutOfStoreSymlink "/mnt/servers/1000xlab/downloads";
      };
    };
  };

}
