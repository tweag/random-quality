{ python3, python37Packages, runCommand, fetchurl, patch }:
let
  src = fetchurl {
    url = "https://gitlab.com/christoph-conrads/rademacher-fpl/-/raw/324fb5ae8f75fd21238b4f45484bc8cd3b8341b5/scripts/detect-significand-bias.py";
    sha256 = "148b93xs2xfh0dwrqwvw6wjh8br2jidqpy0xhk998wa0qjmqdwqn";
  };
  py = python3.withPackages (ps: with python37Packages; [ numpy scipy ]);
  interpreter = "${py}/bin/python";
in
runCommand "detect-significand-bias" {} ''
  mkdir -p $out/bin
  echo "#! ${interpreter}" >> $out/bin/detect-significand-bias
  ${patch}/bin/patch -p1 -o- "${src}" "${./stdin.patch}" | tail -n +2 >> $out/bin/detect-significand-bias
  chmod +x $out/bin/detect-significand-bias
''
