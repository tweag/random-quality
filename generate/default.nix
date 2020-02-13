{ mkDerivation, base, bytestring, random, splitmix, stdenv }:
mkDerivation {
  pname = "generate";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring random splitmix ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
