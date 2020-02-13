{ stdenv, fetchurl, unzip, testu01 }:

stdenv.mkDerivation rec {
  name = "TestU01_stdin";
  src = ./.;
  nativeBuildInputs = [ testu01 ];
  hardeningDisable = [ "format" ];
  buildInputs = [];
  configureFlags = [];
  unpackPhase = "";
  buildPhase = ''
    gcc -std=c99 -O3 -fomit-frame-pointer -mtune=native TestU01_stdin.c -o TestU01_stdin -ltestu01 -lprobdist -lmylib -lm
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp TestU01_stdin $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Empirical Statistical Testing of Uniform Random Number Generators";
    license = licenses.gpl3;
    homepage = http://simul.iro.umontreal.ca/testu01/tu01.html;
    maintainers = [ maintainers.idontgetoutmuch ];
  };
}
