{
  description = "Entry Point for NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    photogimp.url = "github:Libadoxon/nix-photo-gimp";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      
      # Host: home
      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./default.nix
          ./home/default.nix
        ];
      };

    };
  };
}
