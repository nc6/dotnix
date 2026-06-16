{pkgs,lib,...}:
{
  nix = {
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://cache.iog.io"
      ];

      trusted-public-keys = [
        "cache.iog.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
      trusted-users = [ "@wheel" ];
    };

    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-then 30d";

  };

  # Limit the number of configurations to prevent the boot partition filling
  boot.loader.systemd-boot.configurationLimit = 5;

  # Temporarily allow insecure version of electron
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
}
