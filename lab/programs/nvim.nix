{ pkgs, config, lib, username, identity, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
  ];

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${identity.repoPath}/dotfiles/.config/nvim";
  };
}

