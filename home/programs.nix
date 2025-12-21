{ pkgs, inputs, ... }:

{

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.dconf.enable = true;

  programs.thunar.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "kde" ];
      };
      hyprland = {
        default = [ "hyprland" "kde" ];
      };
    };
  };

  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  
  virtualisation.containers.containersConf.settings = {
    containers = {
      log_driver = "k8s-file";
    };
    engine = {
      runtime = "crun";
      events_logger = "file";
      cgroup_manager = "systemd";
    };
  };

}
