{ config, pkgs, inputs, username, ... }:

{

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username; };
    backupFileExtension = "backup"; 
    # Notice the function syntax here: { config, ... }: {
    users.${username} = { config, ... }: {
      home.stateVersion = "25.05";

      imports = [
        
        inputs.xremap.homeManagerModules.default

        ./theme.nix
        ../services/hm/mpd.nix
        ../services/hm/swww.nix
        ../services/hm/wlsunset.nix
        ../services/hm/quickshell.nix
        ../services/hm/listenbrainz-mpd-90-no4m.nix
        ../services/hm/xremap.nix
        ../services/hm/polkit-agent.nix
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
