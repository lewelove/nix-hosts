{ pkgs, lib, username, ... }:

let

  flags = import ./chromium-flags.nix { inherit pkgs lib; };

in

{

  home-manager.users.${username} = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = flags.commonArgs;
    };
  };

}
