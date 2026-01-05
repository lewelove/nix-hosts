{ pkgs, lib, username, ... }:

let

  fetchExtension = { id, version, hash }: {
    inherit id version;
    crxPath = pkgs.fetchurl {
      url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3D${id}%26installsource%3Dondemand%26uc";
      name = "${id}.crx";
      sha256 = hash;
    };
  };

  chromium-web-store = rec {
    id = "";
    drv = pkgs.stdenv.mkDerivation rec {
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
  };

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

  untrap = fetchExtension {
    id = "enboaomnljigfhfjfoalacienlhjlfil";
    version = "9.3.7";
    hash = "sha256-606Xbwjq9c53i/cMsIwOfnDBp0Mf8Ogds6ppEw5lEy0=";
  };

  sideloaded = [
    chromium-web-store
    ublock-origin
  ];

  webstore = [
    untrap
  ];

  extensions = sideloaded ++ webstore;

in

{

  programs.chromium = {
    enable = true;
    extraOpts = {
      "ExtensionSettings" = builtins.listToAttrs (map (ext: {
        name = ext.id;
        value = { installation_mode = "allowed"; };
      }) extensions);
    };
  };
  home-manager.users.${username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;

      extensions = webstore;

      commandLineArgs = [
        "--load-extension=${lib.concatStringsSep "," (map (ext: "${ext.drv}") sideloaded)}"
        "--extension-mime-request-handling=always-prompt-for-install"
        "--no-default-browser-check"
        "--restore-last-session"
        "--force-dark-mode"
      ];
    };
  };

}
