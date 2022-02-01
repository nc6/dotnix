{...}:
{
  nix = {
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://hydra.iohk.io"
      ];

      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };
}
