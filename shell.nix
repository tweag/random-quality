let
  overlay = self: super:
    {
      dieharder = self.callPackage ./nix/dieharder {};
      practrand = self.callPackage ./nix/PractRand {};
      testu01 = self.callPackage ./nix/TestU01 {};
      gjrand = self.callPackage ./nix/gjrand {};
      rademacher-fpl-test = self.callPackage ./nix/rademacher-fpl-test {};

      generate = self.haskellPackages.callPackage ./generate {};
      testu01-stdin = self.callPackage ./testu01-stdin {};
    };

in

{ nixpkgs ? import <nixpkgs> { overlays = [ overlay ]; } }:

  nixpkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = [
      nixpkgs.dieharder
      nixpkgs.practrand
      nixpkgs.testu01
      nixpkgs.gjrand
      nixpkgs.rademacher-fpl-test

      nixpkgs.generate
      nixpkgs.testu01-stdin

      # macOS
      nixpkgs.libiconv
    ];
  }
