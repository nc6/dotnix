
{
  nix = {
    settings.substituters = [
      "https://lean4.cachix.org"
    ];
    settings.trusted-public-keys = [
      "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
    ];
  };
}
