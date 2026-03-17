{ config, pkgs, inputs, username, dot, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username dot; };
    backupFileExtension = "backup"; 
    users.${username} = { config, ... }: {
      home.stateVersion = "25.05";
      
      home.file = {
        ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/fish";
        ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/starship.toml";
      };

      imports = [
      ];
    };
  };
}
