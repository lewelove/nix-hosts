{ pkgs, ... }:

{

  imports = [
    ./theme.nix
    ./services.nix
  ];

  home.stateVersion = "25.05";
  
}
