{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    helix-editor = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, helix-editor, home-manager }: let

  specialArgs = { inherit helix-editor; };

  system = "x86_64-linux";

  lorien = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
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
        home-manager.extraSpecialArgs = specialArgs;

        # Optionally, use home-manager.extraSpecialArgs to pass
        # arguments to home.nix
      }
    ];
  };

  varda = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
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
        home-manager.extraSpecialArgs = specialArgs;

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
          nvd
        ];
    };
  };
}
