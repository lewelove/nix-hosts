{ config, pkgs, username, hostname, ... }:

{
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  documentation = {
    enable = true;
    man.enable = true;
    man.generateCaches = false;
    nixos.enable = false;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
  };

  services.logrotate.enable = false;

  hardware.uinput.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
    KERNEL=="event*", GROUP="input", MODE="0660"
  '';

  systemd.oomd.enable = false;
  systemd.sockets.systemd-oomd.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
}
