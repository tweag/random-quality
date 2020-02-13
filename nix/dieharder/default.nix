{stdenv, fetchurl, gsl}:

stdenv.mkDerivation rec {
  name = "dieharder-3.31.1";
  src = fetchurl {
    url = "http://webhome.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz";
    sha256 = "0zvj9g6y99fz41332q22g4kgnmf9ryf3acvlmi4kamac77w0zzvc";
  };
  nativeBuildInputs = [ gsl ];
  buildInputs = [ ];
  configureFlags = [ "--disable-shared" ];
  patchPhase = ''
    patch -p1 < ${./dieharder-3.31.1-fix-intptr_t-error.patch}
  '';

  meta = with stdenv.lib; {
    description = "Suite of Random Number Tests";
    license     = licenses.gpl2;
    homepage    = http://webhome.phy.duke.edu/~rgb/General/dieharder.php;
    maintainers = [ maintainers.idontgetoutmuch ];
  };
}
