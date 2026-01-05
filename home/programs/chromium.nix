{ pkgs, lib, username, ... }:

let

  exts = import ./chromium-extensions.nix { inherit pkgs lib; };

in

{

  programs.chromium = {
    enable = true;
    extraOpts = {
      "ExtensionSettings" = builtins.listToAttrs (map (ext: {
        name = ext.id;
        value = { installation_mode = "allowed"; };
      }) (exts.sideloaded ++ exts.webstore));
    };
  };

  home-manager.users.${username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--load-extension=${exts.ublock-origin.drv},${exts.untrap.drv}"
        "--extension-mime-request-handling=always-prompt-for-install"
        "--no-default-browser-check"
        "--restore-last-session"
        "--force-dark-mode"
        "--hide-fullscreen-exit-ui"
      ];
    };
  };
}
