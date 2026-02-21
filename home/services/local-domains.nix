{ config, pkgs, lib, ... }:

let
  # Map your domains to their local ports
  localServices = {
    "vscode.home"    = 4444;
    "comfy.home"     = 8188;
    "mpd.home"       = 666;
    "vellum.home"    = 5173;
    "openwebui.home" = 8080;
    "excalidraw.home" = 5000;
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
