{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.liberty = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs self;};
      modules = [
        # Overlays-module makes "nixgl" available in configuration.nix
        # (_: {nixpkgs.overlays = [nixgl.overlay];})
        ./hosts/liberty
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.vasy.imports = [
              ./home
              # stylix.homeManagerModules.stylix
            ];
          };
        }
      ];
    };
  };
}
