{ luajit
, makeScriptWriter
, writeCBin
, writePerlBin
, writePython3Bin
}:

{
  generatePython = writePython3Bin "generate.py" {} ''
    from random import randint
    while True:
        print("{0:08x}".format(randint(0, 0xFFFFFFFF)))
  '';

  generatePerl = writePerlBin "generate.pl" {} ''
    while () {
        printf("%08X", int(rand(0xFFFFFFFF + 1)))
    }
  '';

  generateLua =
    makeScriptWriter { interpreter = "${luajit.interpreter}"; } "/bin/generate.lua" ''
      while true do
          print(string.format("%08x", math.random(0, 0xFFFFFFFF)))
      end
    '';

  generateC = writeCBin "generate.c" {} ''
    #include <stdio.h>
    #include <stdlib.h>

    int main() {
      while (1) {
        printf("%08x\n", rand());
      }
    }
  '';
}
