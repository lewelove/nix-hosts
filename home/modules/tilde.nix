{ identity, username, ... }:

{
  home-manager.users.${username} = { config, ... }: let
    link = config.lib.file.mkOutOfStoreSymlink;
    dot = "${identity.repoPath}/dotfiles";
  in {
    home.file = {
      # --- Root Dotfiles ---
      ".bashrc".source = link "${dot}/.bashrc";
      ".scripts".source = link "${dot}/.scripts";
      ".applications".source = link "${dot}/.applications";

      # --- .config Directories ---
      ".config/fish".source = link "${dot}/.config/fish";
      ".config/starship.toml".source = link "${dot}/.config/starship.toml";
      ".config/nvim".source = link "${dot}/.config/nvim";
      ".config/foot".source = link "${dot}/.config/foot";
      ".config/fuzzel".source = link "${dot}/.config/fuzzel";
      ".config/hypr".source = link "${dot}/.config/hypr";
      ".config/kitty".source = link "${dot}/.config/kitty";
      ".config/mako".source = link "${dot}/.config/mako";
      ".config/mpv".source = link "${dot}/.config/mpv";
      ".config/pipewire".source = link "${dot}/.config/pipewire";
      ".config/quickshell".source = link "${dot}/.config/quickshell";
      ".config/rmpc".source = link "${dot}/.config/rmpc";
      ".config/Thunar".source = link "${dot}/.config/Thunar";
      ".config/wireplumber".source = link "${dot}/.config/wireplumber";
      ".config/xremap".source = link "${dot}/.config/xremap";
      ".config/imv".source = link "${dot}/.config/imv";
      ".config/qt5ct".source = link "${dot}/.config/qt5ct";
      ".config/qt6ct".source = link "${dot}/.config/qt6ct";
      ".config/containers".source = link "${dot}/.config/containers";
      ".config/repomix".source = link "${dot}/.config/repomix";
      ".config/figma-agent".source = link "${dot}/.config/figma-agent";
      ".config/listenbrainz-mpd".source = link "${dot}/.config/listenbrainz-mpd";
      ".config/uwsm".source = link "${dot}/.config/uwsm";

      # --- Individual Config Files ---
      ".config/mimeapps.list".source = link "${dot}/.config/mimeapps.list";
      ".config/gtk-3.0/bookmarks".source = link "${dot}/.config/gtk-3.0/bookmarks";

      # --- External Storage Symlinks ---
      "Downloads/1000xhome".source = link "/run/media/${username}/1000xhome/downloads";
      "Downloads/x2000".source    = link "/run/media/${username}/x2000/downloads";
      "Downloads/1000xlab".source = link "/mnt/servers/1000xlab/downloads";
    };
  };
}
