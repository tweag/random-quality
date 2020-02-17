{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "gjrand";
  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/gjrand/gjrand/gjrand.4.3.0/gjrand.4.3.0.tar.bz2";
    sha256 = "1qzh902phgj5204lnmmghmxa08q3jia6hp7jy6ha8iybms0wci98";
  };

  patchPhase = ''
    patch -p1 < ${./gjrand-4.3.0.0-skip-rda-fix-paths.patch}
  '';
  buildPhase = ''
    pushd src
        bash compile
    popd

    pushd testunif/src
        substituteInPlace mcp.c --subst-var out
        substituteInPlace pmcp.c --subst-var out
        bash compile
    popd

    pushd testfunif/src
        substituteInPlace mcpf.c --subst-var out
        substituteInPlace pmcpf.c --subst-var out
        bash compile
    popd
  '';
  installPhase = ''
    mkdir -p $out/bin $out/testunif-bin $out/testfunif-bin
    cp testunif/mcp testunif/pmcp $out/bin
    cp testunif/bin/* $out/testunif-bin

    cp testfunif/mcpf testfunif/pmcpf testfunif/gen/uni2f $out/bin
    cp testfunif/bin/* $out/testfunif-bin
  '';

  meta = with stdenv.lib; {
    description = "Pseudo-random number generator and test suite";
    license = licenses.gpl3;
    homepage = http://gjrand.sourceforge.net/;
    maintainers = [ maintainers.idontgetoutmuch ];
  };
}
