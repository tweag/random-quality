let overlay = self: super:
{
  testu01 = self.callPackage ./nix/TestU01 { };
  practrand = self.callPackage ./nix/PractRand { };
  dieharder = self.callPackage ./nix/dieharder { };
  generate = self.haskellPackages.callPackage ./generate { };
};

in

{ nixpkgs ? import <nixpkgs> { overlays = [ overlay ]; } }:

nixpkgs.stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    nixpkgs.libiconv
    nixpkgs.testu01
    nixpkgs.practrand
    nixpkgs.dieharder
    nixpkgs.generate
    nixpkgs.gcc
  ];
}

