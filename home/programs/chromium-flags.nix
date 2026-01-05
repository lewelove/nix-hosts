{ pkgs, lib }:

let
  exts = import ./chromium-extensions.nix { inherit pkgs lib; };
  
  standardExtensions = [
    exts.ublock-origin.drv
    exts.untrap.drv
  ];

  extensionString = lib.concatStringsSep "," (map (x: "${x}") standardExtensions);

in
{
  # The unified list of performance and behavior flags
  commonArgs = [
    "--load-extension=${extensionString}"
    "--extension-mime-request-handling=always-prompt-for-install"
    "--no-default-browser-check"
    "--restore-last-session"
    "--force-dark-mode"
    "--hide-scrollbars"
    "--hide-fullscreen-exit-ui"
  ];
}
