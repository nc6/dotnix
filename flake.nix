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

  lorien = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/lorien/configuration.nix
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
    system = "x86_64-linux";
    modules = [
      ./hosts/varda/configuration.nix
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
    system = "x86_64-linux";
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
  };
}
