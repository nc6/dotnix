{
  description = "home-manager configuration";

  inputs = {
    bismuth.url = "git+ssh://git@github.com/nc6/bismuth.git";
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
    voxtype = {
      url = "github:peteonrails/voxtype";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let

  system = "x86_64-linux";

  specialArgs = { inherit inputs; };

  waybarOverlay = final: prev: {
    waybar = prev.waybar.overrideAttrs (old: {
      version = "0.15.0";
      src = prev.fetchFromGitHub {
        owner = "Alexays";
        repo = "Waybar";
        rev = "05945748dccce28bf96d26d8f64a9e69a8dd49ba";
        hash = "sha256-51R3mIt8cLNvh/X5qe9vOqeJCj0U9KRyemVE5y+OhiU=";
      };
      mesonFlags = (old.mesonFlags or []) ++ [ "-Dcava=disabled" ];
    });
  };

  desktopModules = extraModules: [
    { nixpkgs.hostPlatform.system = system; nixpkgs.overlays = [ waybarOverlay ]; }
    ./hosts/common
    home-manager.nixosModules.home-manager
    {
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
      nixpkgs.config = { allowUnfree = true; };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.nc = import ./users/nc/home.nix;
      home-manager.extraSpecialArgs = { voxtype = inputs.voxtype; };
      home-manager.sharedModules = [ inputs.voxtype.homeManagerModules.default ];
    }
  ] ++ extraModules;

  lorien = nixpkgs.lib.nixosSystem {
    modules = desktopModules [ ./hosts/lorien/configuration.nix ];
  };

  varda = nixpkgs.lib.nixosSystem {
    modules = desktopModules [ ./hosts/varda/configuration.nix ];
  };

  orome = nixpkgs.lib.nixosSystem {
    modules = desktopModules [ ./hosts/orome/configuration.nix ];
  };

  ulmo = nixpkgs.lib.nixosSystem {
    modules = desktopModules [
      ./hosts/ulmo/configuration.nix
      inputs.golink.nixosModules.default
    ];
  };

  # Hetzner online
  manwe = nixpkgs.lib.nixosSystem {
    modules = [
      { nixpkgs.hostPlatform.system = system; }
      inputs.disko.nixosModules.disko
      ./hosts/manwe/configuration.nix
      { hardware.facter.reportPath = ./hosts/manwe/facter.json; }
      inputs.sops-nix.nixosModules.sops
      inputs.bismuth.nixosModules.default
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
