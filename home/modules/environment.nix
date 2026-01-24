{ config, pkgs, username, hostname, ... }:

{

  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
       exec uwsm start default
    fi
  '';

  environment.extraInit = ''
    export PATH="$HOME/.commands:$HOME/.scripts:$PATH"
    export XDG_DATA_DIRS="$HOME/.applications:$XDG_DATA_DIRS"
  '';

  environment.sessionVariables = {
    TMPDIR = "/var/tmp";

    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";

    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    XCURSOR_THEME = "Adwaita"; 
    XCURSOR_SIZE = "24";

    FREETYPE_PROPERTIES = "truetype:interpreter-version=40";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_MENU_PREFIX = "plasma-";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    
    EDITOR = "nvim";

  };

}
