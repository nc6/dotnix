
{
  nix = {
    settings.substituters = [
      "https://hie-nix.cachix.org"
    ];
    settings.trusted-public-keys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];

  };
}
