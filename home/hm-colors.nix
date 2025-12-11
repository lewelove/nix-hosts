{ pkgs, config, ... }:

let
  monochromeCss = ''
    /* Force Gray Accent - Libadwaita/GTK4 */
    @define-color accent_color #909090;
    @define-color accent_bg_color #909090;
    @define-color accent_fg_color #ffffff;

    /* Selection Colors */
    @define-color selection_mode_bg_color #909090;
    @define-color selection_mode_fg_color #ffffff;

    /* GTK3 / Legacy Adwaita Overrides */
    @define-color theme_selected_bg_color #909090;
    @define-color theme_selected_fg_color #ffffff;
    @define-color selected_bg_color #909090;
    @define-color selected_fg_color #ffffff;

    /* Destructive (Red) -> Dark Gray */
    @define-color destructive_color #5e5e5e;
    @define-color destructive_bg_color #5e5e5e;
    @define-color destructive_fg_color #ffffff;

    /* Success (Green) -> Gray */
    @define-color success_color #a0a0a0;
    @define-color success_bg_color #a0a0a0;
    @define-color success_fg_color #000000;

    /* Warning (Orange) -> Gray */
    @define-color warning_color #b0b0b0;
    @define-color warning_bg_color #b0b0b0;
    @define-color warning_fg_color #000000;
    
    /* Error (Red) -> Gray */
    @define-color error_color #5e5e5e;
    @define-color error_bg_color #5e5e5e;
    @define-color error_fg_color #ffffff;
  '';
in
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

      # Inject color overrides (GTK4 reads this for Libadwaita apps)
      # GTK3 apps using adw-gtk3 will also respect these overrides
      gtk3.extraCss = monochromeCss;
      gtk4.extraCss = monochromeCss;
    };
    
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };
  };
}
