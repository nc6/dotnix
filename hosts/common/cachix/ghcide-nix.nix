
{
  nix = {
    settings.substituters = [
      "https://ghcide-nix.cachix.org"
    ];
    settings.trusted-public-keys = [
      "ghcide-nix.cachix.org-1:ibAY5FD+XWLzbLr8fxK6n8fL9zZe7jS+gYeyxyWYK5c="
    ];
  };
}
