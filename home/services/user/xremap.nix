{ xremap, config, ... }:

{
  services.xremap = {
    enable = true;
    withHypr = true;

    yamlConfig = builtins.readFile ./../../tilde/.config/xremap/config.yml;

    watch = true;
  };
}
