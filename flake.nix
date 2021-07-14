{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = { self, ... }@inputs:
    {
      nixosConfigurations = {
        plumfive = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/plumfive ];
          extraArgs = { inputs = inputs; };
        };
      };
      # Exported to allow using flake checkout as channel
      legacyPackages.x86_64-linux =
        (builtins.head (builtins.attrValues self.nixosConfigurations)).pkgs;
    };
}
