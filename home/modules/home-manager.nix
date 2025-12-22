{ config, pkgs, inputs, username, ... }:

{

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username; };
    backupFileExtension = "backup"; 
    users.${username} = {
      home.stateVersion = "25.05";
      imports = [
        ./theme.nix
        ../services/user/mpd.nix
        ../services/user/swww.nix
        ../services/user/wlsunset.nix
        ../services/user/quickshell.nix
        ../services/user/listenbrainz-mpd-90-no4m.nix
        ../services/user/xremap.nix
      ];
    };
  };

}
