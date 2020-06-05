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
      inherit (self.callPackage ./nix/generators.nix {
        inherit (self.writers)
          makeScriptWriter
          writeCBin
          writePerlBin
          writePython3Bin
          ;
      })
        generateC
        generateLua
        generatePerl
        generatePython
        ;
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
    generateC
    generateLua
    generatePerl
    generatePython

    # utilities
    xxd
  ] ++ stdenv.lib.optionals buildHaskell [
    generate
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ];
}
