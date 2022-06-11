{...}:
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
    };
    trustedUsers = [ "@wheel" ];
  };
}
