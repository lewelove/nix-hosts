{ pkgs, username, ... }:

{
  fonts = {
    packages = with pkgs; [
      inter
      nerd-fonts.commit-mono
      commit-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      useEmbeddedBitmaps = false;
      defaultFonts = {
        monospace = [
          "CommitMono Nerd Font"
          "Noto Sans Mono CJK JP"
          # "Noto Color Emoji"
        ];
        sansSerif = [
          "Inter"
          "Noto Sans"
          "Noto Sans CJK JP"
          "Noto Sans Arabic"
          "Noto Sans Thai"
          "Noto Color Emoji"
        ];
        serif = [
          "Inter"
          "Noto Serif"
          "Noto Serif CJK JP"
          "Noto Serif Arabic"
          "Noto Serif Thai"
          "Noto Color Emoji"
        ];
      };
    };
  };

  home-manager.users.${username} = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Adwaita";
        font-antialiasing = "rgba";
        font-rgba-order = "rgb";
        font-hinting = "slight";
      };
    };

    gtk = {
      enable = true;
      font = {
        name = "Inter";
        size = 11;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };
  };
}
