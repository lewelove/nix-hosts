{ pkgs, username, dot, ... }:

{
  programs.fish = {
    enable = true;
  };

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/fish";
  };
}

