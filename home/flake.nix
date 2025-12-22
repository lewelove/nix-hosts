{
  description = "Entry Point for NixOS Configuration";

  inputs = {
    # System
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Other Flakes
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    photogimp.url = "github:Libadoxon/nix-photo-gimp";
    xremap.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    identity = import ./identity.nix;
  in {
    nixosConfigurations.${identity.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit (identity) username hostname;
        repoPath = "/home/${identity.username}/nix-hosts/home";
      };
        modules = [ ./default.nix ];
    };
  };
}
