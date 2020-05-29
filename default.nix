{ pkgsSrc ? ./nix/nixpkgs.nix
, buildHaskell ? false
}:
let
  overlay = self: super:
    {
      # tests
      dieharder = self.callPackage ./nix/dieharder {};
      gjrand = self.callPackage ./nix/gjrand {};
      practrand = self.callPackage ./nix/PractRand {};
      rademacher-fpl-test = self.callPackage ./nix/rademacher-fpl-test {};
      testu01 = self.callPackage ./nix/TestU01 {};
      testu01-stdin = self.callPackage ./testu01-stdin {};

      # generators
      generate = self.haskellPackages.callPackage ./generate {};
    };
  pkgs = import pkgsSrc { overlays = [ overlay ]; };
in
pkgs.mkShell {
  name = "env";
  buildInputs = with pkgs; [
    # tests
    dieharder
    gjrand
    practrand
    rademacher-fpl-test
    testu01
    testu01-stdin

    # generators
    generate

    # utilities
    luajit
    xxd
  ] ++ stdenv.lib.optionals buildHaskell [
    generate
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ];
}
