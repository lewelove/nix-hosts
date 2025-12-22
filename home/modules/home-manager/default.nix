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
      ];
    };
  };
}
