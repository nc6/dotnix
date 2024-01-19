{pkgs,lib,...}:
{
  nix = {
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
    settings = {
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
  };

  # Electron 25.9.0 is EOL. Allow it for now
  nixpkgs.config.permittedInsecurePackages = [
    lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0"
  ];
}
