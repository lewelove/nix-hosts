{ pkgs, config, ... }:

{
  home-manager.users.lewelove = { pkgs, ... }: {
    home.stateVersion = "25.05";
    
    # 1. Manually link the theme files so GTK3 can find them
    # This fixes Thunar being white/default
    home.file = {
      ".local/share/themes/adw-gtk3-dark" = {
        source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark";
      };
      ".local/share/themes/adw-gtk3" = {
        source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3";
      };
    };

    # 2. Dconf settings (Still needed for cursor & dark mode preference)
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Adwaita";
      };
    };

    # 3. GTK Configuration
    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      font = {
        name = "Sans";
        size = 11;
      };

      # Tell GTK3 apps (Thunar) to use the theme we linked above
      gtk3.extraConfig = {
        gtk-theme-name = "adw-gtk3-dark";
        gtk-application-prefer-dark-theme = 1;
      };
    };
    
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };
  };
}
