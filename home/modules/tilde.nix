{ identity, username, ... }:

{
  home-manager.users.${username} = { config, ... }: let
    link = config.lib.file.mkOutOfStoreSymlink;
    dot = "${identity.repoPath}/dotfiles";
  in {
    home.file = {
      # --- .config Directories (Not yet modularized) ---
      ".config/foot".source = link "${dot}/.config/foot";
      ".config/fuzzel".source = link "${dot}/.config/fuzzel";
      ".config/hypr".source = link "${dot}/.config/hypr";
      ".config/kitty".source = link "${dot}/.config/kitty";
      ".config/mako".source = link "${dot}/.config/mako";
      ".config/mpv".source = link "${dot}/.config/mpv";
      ".config/pipewire".source = link "${dot}/.config/pipewire";
      ".config/wireplumber".source = link "${dot}/.config/wireplumber";
      ".config/xremap".source = link "${dot}/.config/xremap";
      ".config/imv".source = link "${dot}/.config/imv";
      ".config/qt5ct".source = link "${dot}/.config/qt5ct";
      ".config/qt6ct".source = link "${dot}/.config/qt6ct";
      ".config/containers".source = link "${dot}/.config/containers";
      ".config/uwsm".source = link "${dot}/.config/uwsm";

      # --- External Storage Symlinks ---
      "Downloads/1000xhome".source = link "/run/media/${username}/1000xhome/downloads";
      "Downloads/x2000".source    = link "/run/media/${username}/x2000/downloads";
      "Downloads/1000xlab".source = link "/mnt/servers/1000xlab/downloads";
    };
  };
}
