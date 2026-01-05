{ pkgs, lib }:

let

  extensions = import ./chromium-extensions.nix { inherit pkgs lib; };

  loadExtensions = e: "--load-extension=${lib.concatStringsSep "," (map (x: "${x.drv}") e)}";

in

{

  inherit extensions;

  baseExts = loadExtensions extensions.base;

  youtubeExts = loadExtensions extensions.youtube;

  common = [
    "--extension-mime-request-handling=always-prompt-for-install"
    "--no-default-browser-check"
    "--force-dark-mode"
    "--hide-fullscreen-exit-ui"
    "--hide-scrollbars"
    "--restore-last-session"
  ];

}
