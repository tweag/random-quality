let
  src = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
in
import (
  builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${src.rev}.tar.gz";
    sha256 = src.sha256;
  }
)
