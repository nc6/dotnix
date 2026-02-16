{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    golink.url = "github:tailscale/golink";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  # Hetzner online
  manwe = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      inputs.disko.nixosModules.disko
      ./hosts/manwe/configuration.nix
      { hardware.facter.reportPath = ./hosts/manwe/facter.json; }
      inputs.sops-nix.nixosModules.sops
      home-manager.nixosModules.home-manager
      {
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
        nixpkgs.config = {
          allowUnfree = true;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.nc = import ./users/nc/headless.nix;

        # Optionally, use home-manager.extraSpecialArgs to pass
        # arguments to home.nix
      }
    ];
  };

  in {
    nixosConfigurations = {
      inherit lorien varda orome ulmo manwe;
    };
    homeConfigurations = {
    };

    deploy.nodes.manwe = {
      hostname = "142.132.195.27";
      profiles.system = {
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.manwe;
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    devShells.${system}.default = let pkgs = nixpkgs.legacyPackages.${system}; in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          jujutsu
          nvd
          sops
        ];
    };
  };
}
