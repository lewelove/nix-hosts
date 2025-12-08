{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./scripts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Network ---
  networking.networkmanager.enable = true;

  # --- User Configuration ---
  users.users.lewe = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.bash; 
  };

  # --- Environment Variables ---
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    # Zen Appearance
    GTK_THEME = "adw-gtk3";
    XCURSOR_THEME = "Adwaita"; 
    XCURSOR_SIZE = "24";
    
    EDITOR = "nvim";
  };
  
  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
