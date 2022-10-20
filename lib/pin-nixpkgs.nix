{ config, pkgs, inputs, ... }:

{
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
