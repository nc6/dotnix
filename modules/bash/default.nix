{...}:
{
  programs.bash = {
    enable = true;
    historyFileSize = 1000000;
    historyIgnore = [ "ls" "ll" "cd" "clear" ];

    bashrcExtra = ''
      function ghciwith () {
        nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [$*])" --run ghci
      }

      function ghci9with () {
        nix-shell -p "haskell.packages.ghc924.ghcWithPackages (pkgs: with pkgs; [$*])" --run ghci
      }

      eval "$(zoxide init bash)"
    '';
  };
}
