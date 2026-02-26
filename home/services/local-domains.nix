{ config, pkgs, lib, ... }:

let
  localServices = {
    "vscode.localhost"     = 4444;
    "comfy.localhost"      = 8188;
    "mpd.localhost"        = 666;
    "vellum.localhost"     = 5173;
    "openwebui.localhost"  = 8080;
    "excalidraw.localhost" = 5000;
  };

in {

  networking.hosts."127.0.0.1" = builtins.attrNames localServices;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts = lib.mapAttrs (domain: port: {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      };
    }) localServices;
  };

  services.logrotate.enable = false;

}
