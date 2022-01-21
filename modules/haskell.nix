{pkgs,...}:
{
  home.packages = with pkgs.haskellPackages; [
    cabal-install
    pkgs.haskell.compiler.ghc921
    apply-refact
    # friendly
    ghcid
    hasktags
    hlint
    hoogle
    ormolu
    profiteur
    profiterole
    stylish-haskell
  ];
}
