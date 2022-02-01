
{
  nix = {
    settings.substituters = [
      "https://tweag.cachix.org"
    ];
    settings.trusted-public-keys = [
      "tweag.cachix.org-1:1kI0+PcOXktlm12UUDAEz7SErbLXsxOEKaEsAjxT8Dg="
    ];

  };
}
