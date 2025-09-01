{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    golink.url = "github:tailscale/golink";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let

  system = "x86_64-linux";

  specialArgs = { inherit inputs; };

  lorien = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./hosts/common
      ./hosts/lorien/configuration.nix
      home-manager.nixosModules.home-manager
      {
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
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
    modules = [
      ./hosts/common
      ./hosts/varda/configuration.nix
      home-manager.nixosModules.home-manager
      {
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
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

  orome = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./hosts/common
      ./hosts/orome/configuration.nix
      home-manager.nixosModules.home-manager
      {
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
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

  ulmo = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./hosts/common
      ./hosts/ulmo/configuration.nix
      inputs.golink.nixosModules.default
      home-manager.nixosModules.home-manager
      {
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
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
      inherit lorien varda orome ulmo;
    };
    homeConfigurations = {
      inherit build01;
    };

    devShells.${system}.default = let pkgs = nixpkgs.legacyPackages.${system}; in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          nvd
        ];
    };
  };
}
