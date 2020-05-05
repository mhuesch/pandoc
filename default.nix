let
  haskellNix = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/949b2dffa816a758c1e9a3db3aa49d1a0c06968b.tar.gz) {};
  # haskell.nix provides access to the nixpkgs pins which are used by our CI, hence
  # you will be more likely to get cache hits when using these.
  # But you can also just use your own, e.g. '<nixpkgs>'
  nixpkgsSrc = haskellNix.sources.nixpkgs-2003;
  # haskell.nix provides some arguments to be passed to nixpkgs, including some patches
  # and also the haskell.nix functionality itself as an overlay.
  nixpkgsArgs = haskellNix.nixpkgsArgs;
in
{ pkgs ? import nixpkgsSrc nixpkgsArgs
, haskellCompiler ? "ghc865"
}:
# 'cabalProject' generates a package set based on a cabal.project (and the corresponding .cabal files)
pkgs.haskell-nix.cabalProject {
  # 'cleanGit' cleans a source directory based on the files known by git
  src = pkgs.haskell-nix.haskellLib.cleanGit { name = "pandoc"; src = ./.; };

  # mhueschen: we should do `s/ghc/compiler-nix-name`, but that causes something to break
  compiler-nix-name = haskellCompiler;
}
