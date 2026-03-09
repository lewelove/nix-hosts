{ pkgs, config, lib, username, identity, ... }:

let
  nvl = pkgs.writeShellScriptBin "nvl" ''
    exec ${pkgs.alacritty}/bin/alacritty --class "nvim" -e ${pkgs.neovim}/bin/nvim "$@"
  '';
in
{
  environment.systemPackages = [ 
    pkgs.neovim 
    nvl 
  ];

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${identity.repoPath}/dotfiles/.config/nvim";

    xdg.desktopEntries.nvl = {
      name = "Neovim (Launcher)";
      genericName = "Text Editor";
      comment = "Edit text files in Neovim";
      exec = "nvl %F";
      icon = "nvim";
      terminal = false;
      categories = [ "Utility" "TextEditor" "Development" ];
    };
  };
}
