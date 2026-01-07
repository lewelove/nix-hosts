{ config, pkgs, username, hostname, ... }:

{

  # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts = {
    packages = with pkgs; [
      nerd-fonts.commit-mono
      commit-mono
      noto-fonts
      noto-fonts-color-emoji
      # corefonts
      # vista-fonts
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
        monospace = [ "CommitMono Nerd Font" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Arial" "Noto Color Emoji" ];
        serif     = [ "Noto Serif" "Times New Roman" "Noto Color Emoji" ];
      };
    };
  };

  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
    KERNEL=="event*", GROUP="input", MODE="0660"
  '';

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11"; 

}
