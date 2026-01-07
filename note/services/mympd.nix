{ config, pkgs, ... }:

{
  
  services.mympd = {
    enable = true;
    settings = {
      http_port = 666;
    };
  };

}
