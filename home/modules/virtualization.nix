{ pkgs, inputs, ... }:

{

  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  
  virtualisation.containers.containersConf.settings = {
    containers = {
      log_driver = "k8s-file";
    };
    storage = {
      driver = "overlay";
    };
    engine = {
      runtime = "runc";
      events_logger = "file";
      cgroup_manager = "systemd";
    };
  };

}
