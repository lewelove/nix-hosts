{ config, pkgs, username, hostname, ... }:

{

  # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- User Configuration ---
  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel"  "input" "uinput" ];
    shell = pkgs.bash; 
    autoSubUidGidRange = true;
  };

  security.sudo.extraRules = [
    {
      users = [ "${username}" ];
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

  # --- Boot ---
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  # --- Network ---
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 8080 6600 ];

  # --- Bluetooth ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        Enable = "Source,Sink,Media,Socket";
        AutoConnect = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;

  services.getty.autologinUser = "${username}";

  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
       exec uwsm start default
    fi
  '';

  # --- Environment Variables ---
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    # Appearance
    XCURSOR_THEME = "Adwaita"; 
    XCURSOR_SIZE = "24";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_MENU_PREFIX = "plasma-";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    
    EDITOR = "nvim";

    PATH = [
      "$HOME/.commands"
      "$HOME/.scripts"
    ];

    XDG_DATA_DIRS = [
      "$HOME/.applications"
    ];

  };
  
  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
    commit-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

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
