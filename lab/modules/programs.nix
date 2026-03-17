{ pkgs, inputs, ... }:

{

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.fish.enable = true;

}
