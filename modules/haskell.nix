{pkgs,...}:
{
	home.packages = with pkgs.haskellPackages; [
    cabal-install
    haskell.compiler.ghc921
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
