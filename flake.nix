{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager }: let

  system = "x86_64-linux";

  lorien = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/lorien/configuration.nix
      ./lib/pin-nixpkgs.nix
      home-manager.nixosModules.home-manager
      {
        nixpkgs.config = {
          allowUnfree = true;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.nc = import ./users/nc/home.nix;

        # Optionally, use home-manager.extraSpecialArgs to pass
        # arguments to home.nix
      }
    ];
  };

  varda = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/varda/configuration.nix
      ./lib/pin-nixpkgs.nix
      home-manager.nixosModules.home-manager
      {
        nixpkgs.config = {
          allowUnfree = true;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.nc = import ./users/nc/home.nix;

        # Optionally, use home-manager.extraSpecialArgs to pass
        # arguments to home.nix
      }
    ];
  };

  build01 = home-manager.lib.homeManagerConfiguration rec {
    inherit system;
    username = "nc";
    homeDirectory = "/home/nc";
    configuration = import ./users/nc/home.nix;
  };

  in {
    nixosConfigurations = {
      inherit lorien varda;
    };
    homeConfigurations = {
      inherit build01;
    };

    devShells.${system}.default = let pkgs = nixpkgs.legacyPackages.${system}; in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          just
        ];
    };
  };
}
