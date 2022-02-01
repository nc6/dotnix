
{
  nix = {
    settings.substituters = [
      "https://jupyterwith.cachix.org"
    ];
    settings.trusted-public-keys = [
      "jupyterwith.cachix.org-1:/kDy2B6YEhXGJuNguG1qyqIodMyO4w8KwWH4/vAc7CI="
    ];
  };
}
