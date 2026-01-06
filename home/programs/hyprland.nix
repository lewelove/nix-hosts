{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };
}
