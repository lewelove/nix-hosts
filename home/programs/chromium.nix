{ pkgs, lib, username, config, ... }:

let
  fetchExtension = { id, version, hash }: let
    crx = pkgs.fetchurl {
      url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3D${id}%26installsource%3Dondemand%26uc";
      name = "${id}.crx";
      sha256 = hash;
    };
  in {
    inherit id;
    drv = pkgs.runCommand "ext-${id}" { nativeBuildInputs = [ pkgs.unzip ]; } ''
      unzip ${crx} -d $out || true
    '';
  };

  extensions = {
    ublock-origin = rec {
      id = "mdcpogggagpjibjhpohkefbfgfaepcik";
      drv = pkgs.stdenv.mkDerivation rec {
        pname = "ublock-origin";
        version = "1.68.0";
        src = pkgs.fetchurl {
          url = "https://github.com/gorhill/uBlock/releases/download/${version}/uBlock0_${version}.chromium.zip";
          hash = "sha256-lpb7CN2QbnH10gD+EH7YUptQMri1kLTUz0nTvxMgEOM=";
        };
        nativeBuildInputs = [ pkgs.unzip ];
        unpackPhase = "unzip $src -d .";
        installPhase = "mkdir -p $out; cp -r uBlock0.chromium/* $out/";
      };
    };
  
    sponsorblock = fetchExtension {
      id = "mnjggcdmjocbbbhaepdhchncahnbgone";
      version = "6.1.2";
      hash = "sha256-Nnud/gWl8DVIUa4g4oDYklDZclQRklHl5Uxvh/aEPYQ=";
    };

    untrap = fetchExtension {
      id = "enboaomnljigfhfjfoalacienlhjlfil";
      version = "9.3.7";
      hash = "sha256-ePj7aR8iOvpDYs1QpaY35UEuLLhIpRjHhSDZuJkstKc=";
    };
  };

  windowUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

  trustedOrigins = "http://vscode.localhost,http://vellum.localhost,http://qbittorrent.lab,http://excalidraw.localhost";

  commonArgs = [
    "--test-type"
    "--unsafely-treat-insecure-origin-as-secure=${trustedOrigins}"
    "--load-extension=${extensions.ublock-origin.drv},${extensions.untrap.drv},${extensions.sponsorblock.drv}"
    "--extension-mime-request-handling=always-prompt-for-install"
    "--no-default-browser-check"
    "--restore-last-session"
    "--force-dark-mode"
    "--hide-scrollbars"
    "--hide-fullscreen-exit-ui"
    "--user-agent=\"${windowUserAgent}\""
    "--disable-features=BlockInsecurePrivateNetworkRequests,WaylandWpColorManagerV1"
    "--force-color-profile=srgb"
  ];

  chromiumWrapper = pkgs.writeShellScriptBin "chromium-browser" ''
    exec ${pkgs.ungoogled-chromium}/bin/chromium \
      ${lib.strings.escapeShellArgs commonArgs} \
      "$@" >/dev/null 2>&1
  '';

in
{
  options.my.chromium.wrapper = lib.mkOption {
    type = lib.types.package;
    default = chromiumWrapper;
    description = "Wrapped Chromium package with default flags applied";
  };

  config = {
    home-manager.users.${username} = {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = commonArgs; 
      };

      systemd.user.services.chromium-service = {
        Unit = {
          Description = "Chromium Background Service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${chromiumWrapper}/bin/chromium-browser --silent-launch";
          Restart = "on-failure";
          RestartSec = "5s";
          Environment = [ "XDG_CURRENT_DESKTOP=Hyprland" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
