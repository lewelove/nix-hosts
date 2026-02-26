{ config, pkgs, lib, ... }:

let
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
      forceSSL = true;
      
      sslCertificate = "/etc/ssl/local/${domain}.pem";
      sslCertificateKey = "/etc/ssl/local/${domain}-key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      };
    }) localServices;
  };

  # Ensure Nginx has access to the directory
  systemd.services.nginx.serviceConfig.ReadOnlyPaths = [ "/etc/ssl/local" ];

  services.logrotate.enable = false;

}
