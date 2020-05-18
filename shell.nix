let
  overlay = self: super:
    {
      dieharder = self.callPackage ./nix/dieharder {};
      gjrand = self.callPackage ./nix/gjrand {};
      practrand = self.callPackage ./nix/PractRand {};
      rademacher-fpl-test = self.callPackage ./nix/rademacher-fpl-test {};
      testu01 = self.callPackage ./nix/TestU01 {};
      testu01-stdin = self.callPackage ./testu01-stdin {};
    };

in

{ nixpkgs ? import <nixpkgs> { overlays = [ overlay ]; } }:

  nixpkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = [
      nixpkgs.dieharder
      nixpkgs.gjrand
      nixpkgs.practrand
      nixpkgs.rademacher-fpl-test
      nixpkgs.testu01
      nixpkgs.testu01-stdin

      # macOS
      nixpkgs.libiconv
    ];
  }
