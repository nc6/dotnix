{ voxtype, pkgs, ... }:
{
  programs.voxtype = {
    enable = true;
    package = voxtype.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
    model.name = "base.en";
    service.enable = true;
    settings = {
      hotkey.enabled = false;
    };
  };
}
