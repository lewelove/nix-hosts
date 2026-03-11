{ pkgs, username, dot, ... }:

{
  programs.thunar.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/Thunar".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/Thunar";
  };
}
