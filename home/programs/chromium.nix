{ pkgs, username, ... }:

let

  chromiumWebStore = pkgs.stdenv.mkDerivation rec {
    pname = "chromium-web-store";
    version = "1.5.5.2";
    src = pkgs.fetchFromGitHub {
      owner = "NeverDecaf";
      repo = "chromium-web-store";
      rev = "v${version}";
      hash = "sha256-Rr0KVs6Ztqz04CpQSDThn/hi6VZdVZsztPSALUY/fnE=";
    };
    installPhase = "mkdir -p $out; cp -r src/* $out/";
  };

  ublockOrigin = pkgs.stdenv.mkDerivation rec {
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

  extensions = "${chromiumWebStore},${ublockOrigin}";

  ublockId = "mdcpogggagpjibjhpohkefbfgfaepcik";

in

{

  programs.chromium = {
    enable = true;
    extraOpts = {
      "ExtensionSettings" = {
        "${ublockId}" = {
          "installation_mode" = "allowed";
        };
      };
      "ExtensionInstallAllowlist" = [ ublockId ];
      "DeveloperToolsAvailability" = 1;
    };
  };

  home-manager.users.${username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--load-extension=${extensions}"
        "--extension-mime-request-handling=always-prompt-for-install"
        "--no-default-browser-check"
        "--restore-last-session"
        "--force-dark-mode"
      ];
    };
  };

}
