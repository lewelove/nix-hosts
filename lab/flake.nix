{
  description = "Entry Point for NixOS Configuration";

  inputs = {
    # System
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    openclaw.url = "github:openclaw/nix-openclaw";

    summarize.url = "github:openclaw/nix-steipete-tools?dir=tools/summarize";
    summarize.inputs.nixpkgs.follows = "nixpkgs";
    
    oracle.url = "github:openclaw/nix-steipete-tools?dir=tools/oracle";
    oracle.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    identity = import ./identity.nix;
    hostPath = "${identity.repoPath}/${identity.hostname}";
  in {
    nixosConfigurations.${identity.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs identity hostPath;
        inherit (identity) username hostname repoPath;
      };
      modules = [
        inputs.disko.nixosModules.disko
        ./default.nix
      ];
    };
  };
}
