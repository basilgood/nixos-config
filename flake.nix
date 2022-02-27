{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.kitty-themes = {
    url = "github:connorholyday/nord-kitty";
    flake = false;
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs.lib) nixosSystem mapAttrs;
      inherit (nixpkgs.legacyPackages.x86_64-linux) mkShell;
      system = "x86_64-linux";
      mkSystem = system: module:
        nixosSystem {
          specialArgs = { inherit inputs; };

          inherit system;
          modules = [ module { nixpkgs.overlays = [ self.overlay ]; } ];
        };

      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.plumfive = mkSystem "x86_64-linux" ./hosts/plumfive;
      # nixosConfigurations.hermes = mkSystem "x86_64-linux" ./hosts/hermes;
      overlay = final: prev: (import ./pkgs/overlay.nix inputs final prev);
    };
}
