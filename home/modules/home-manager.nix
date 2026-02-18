
{ config, pkgs, inputs, username, ... }:

{

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username; };
    backupFileExtension = "backup"; 
    users.${username} = { config, ... }: {
      home.stateVersion = "25.05";

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        download = "/run/media/${username}/1000xhome/downloads";
      };

    };
  };

}
