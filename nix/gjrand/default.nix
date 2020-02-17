{ stdenv, fetchurl, unzip, gcc}:

stdenv.mkDerivation {
  name = "gjrand";
  nativeBuildInputs = [ gcc ];
  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/gjrand/gjrand/gjrand.4.3.0/gjrand.4.3.0.tar.bz2";
    sha256 = "1qzh902phgj5204lnmmghmxa08q3jia6hp7jy6ha8iybms0wci98";
  };

  buildPhase = ''
    pushd src
    bash compile
    popd

    pushd testunif/src
    bash compile
    popd
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp testunif/pmcp $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Pseudo-random number generator and test suite";
    license = licenses.gpl3;
    homepage = http://gjrand.sourceforge.net/;
    maintainers = [ maintainers.idontgetoutmuch ];
  };
}
