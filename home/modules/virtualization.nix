{ pkgs, inputs, ... }:

{

  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = [ pkgs.nvidia-container-toolkit ];
  };
  
  virtualisation.containers.containersConf.settings = {
    containers = {
      log_driver = "k8s-file";
    };
    storage = {
      driver = "btrfs";
    };
    engine = {
      runtime = "crun";
      events_logger = "file";
      cgroup_manager = "systemd";
    };
  };

}
