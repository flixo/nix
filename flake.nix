{
  description = "nix";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs, utils, home-manager, nixos-hardware, nix-flatpak, ... }@inputs:
    let
      overlays = [];
      mkHome = import ./lib/mkHome.nix { inherit nixpkgs home-manager inputs; };
      mkSystem = import ./lib/mkSystem.nix { inherit nixpkgs overlays inputs nixos-hardware; };
    in {
      # Home manager configurations
      # homeConfigurations.nix-vm = mkHome "nix-vm" { stateVersion = "25.05"; };
      nixosConfigurations = {
        nix-vm = mkSystem "nix-vm" {
          extraModules = [ 
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
        nixos-vm-hyperv = mkSystem "nixos-vm-hyperv" {
          extraModules = [
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}
