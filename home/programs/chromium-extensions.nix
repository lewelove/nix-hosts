{ pkgs, lib, ... }:

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

in

{

  inherit ublock-origin chromium-web-store untrap;

  sideloaded = [ ublock-origin ];
  webstore = [ untrap ];

}
