{ config, pkgs, ... }:

{
  imports = [
    ./scripts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Network ---
  networking.networkmanager.enable = true;

  # --- User Configuration ---
  users.users.lewelove = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash; 
    autoSubUidGidRange = true;
  };

  security.sudo.extraRules = [
    {
      users = [ "lewelove" ];
      commands = [
        { 
          command = "/run/current-system/sw/bin/killall";
          options = [ "NOPASSWD" ];
        }
        { 
          command = "/run/current-system/sw/bin/awg-quick";
          options = [ "NOPASSWD" ];
        }
        { 
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];


  # --- Environment Variables ---
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    # Appearance
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
