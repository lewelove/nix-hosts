{ pkgs, config, lib, username, identity, ... }:

let
  launcher-bin = pkgs.writeShellScriptBin "nvim-launcher" ''
    exec ${pkgs.kitty}/bin/kitty --app-id nvim-launcher -e ${pkgs.neovim}/bin/nvim "$@"
  '';

  textMimeTypes = [
    "text/plain"
    "text/markdown"
    "text/x-shellscript"
    "text/x-lua"
    "text/x-python"
    "text/x-c"
    "text/x-c++"
    "application/json"
    "application/xml"
    "application/toml"
    "application/x-yaml"
    "text/x-log"
  ];
in
{
  # Install Neovim and the custom launcher globally
  environment.systemPackages = [ 
    pkgs.neovim 
    launcher-bin 
  ];

  home-manager.users.${username} = { config, ... }: {
    # Symlink the nvim config directory
    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${identity.repoPath}/dotfiles/.config/nvim";

    # Create the Desktop Entry for system-wide MIME handling
    xdg.desktopEntries.nvim-launcher = {
      name = "Neovim (Launcher)";
      genericName = "Text Editor";
      comment = "Edit text files in Neovim via Kitty";
      exec = "nvim-launcher %F";
      icon = "nvim";
      terminal = false;
      categories = [ "Utility" "TextEditor" "Development" ];
      mimeType = textMimeTypes;
    };
  };
}
