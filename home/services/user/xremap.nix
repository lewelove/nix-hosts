{ xremap, config, ... }:

{
  services.xremap = {
    enable = true;
    withHypr = true;
    serviceMode = "user";
    userName = "lewelove";

    yamlConfig = builtins.readFile "${config.home.homeDirectory}/.config/xremap/config.yml";

    watch = true;
  };
}
