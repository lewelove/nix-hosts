{ pkgs, username, dot, ... }:

{
  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
  
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.fuse.userAllowOther = true;

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  home-manager.users.${username} = { config, ... }: {
    home.file = {
      ".bashrc".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.bashrc";
      ".scripts".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.scripts";
      ".applications".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.applications";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/starship.toml";
      ".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/mimeapps.list";
      ".config/repomix".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/repomix";
    };
  };
}
