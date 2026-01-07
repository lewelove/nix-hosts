{ pkgs, ... }:

{

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      grim
      slurp
      waybar
    ];
  };

  services.displayManager.sessionPackages = [ pkgs.sway ];

}
