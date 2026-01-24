{ config, pkgs, username, hostname, ... }:

{

  # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Fonts ---
  fonts = {
    packages = with pkgs; [
      nerd-fonts.commit-mono
      commit-mono

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      corefonts
      vista-fonts
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

      useEmbeddedBitmaps = true;

      defaultFonts = {
        monospace = [ 
          "CommitMono Nerd Font" 
          "Noto Sans Mono CJK JP" 
          "Noto Color Emoji" 
        ];
        sansSerif = [ 
          "Noto Sans" 
          "Noto Sans CJK JP" 
          "Noto Sans Arabic"
          "Noto Sans Thai"
          "Noto Color Emoji" 
        ];
        serif = [ 
          "Noto Serif" 
          "Noto Serif CJK JP" 
          "Noto Serif Arabic"
          "Noto Serif Thai"
          "Noto Color Emoji" 
        ];
      };
    };
  };

  hardware.uinput.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    # cudaSupport = true;
    # cudaCapabilities = [ "6.1" ];
    # allowUnsupportedSystem = true;
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
    KERNEL=="event*", GROUP="input", MODE="0660"
  '';

  systemd.oomd.enable = false;

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 

}
