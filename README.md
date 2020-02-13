# Introduction

There are many now quite venerable and newer test suites that will
check the quality of random number generators but none of them are
particularly easy to install and use:

  * [dieharder](http://webhome.phy.duke.edu/~rgb/General/dieharder.php "venerable")
  * [TestU01 (SmallCrush, Crush, BigCrush)](http://simul.iro.umontreal.ca/testu01/tu01.html "venerable")
  * [PractRand](http://pracrand.sourceforge.net/ "active")

This repo provides a <kbd>nix-shell</kbd> which will build
<kbd>dieharder</kbd>, <kbd>TestU01</kbd> and <kbd>PractRand</kbd> and
allow you (in the nix shell) to use them almost all identically with
the minimum amount of fuss.

In addition, this repo contains a Haskell program that will generate a
stream of random numbers from some of the Haskell random number
generator implementations.

# Instructions

  * Clone the repo

  ``` shell
  git clone https://github.com/tweag/random-quality.git
  cd random-quality
  nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/19.09.tar.gz
   ```

# Acknowledgements

[Peter Occil](https://github.com/peteroupc) for pointing out the
method for testing generators that support
[split](https://hackage.haskell.org/package/random-1.1/docs/System-Random.html#v:split)
method:

  * [Testing PRNGs for High-Quality Randomness](https://github.com/peteroupc/peteroupc.github.io/blob/master/randomtest.md#testing-prngs-for-high-quality-randomness)
  * [Evaluation of splittable pseudo-random generators](https://www.cambridge.org/core/journals/journal-of-functional-programming/article/evaluation-of-splittable-pseudorandom-generators/3EBAA9F14939C5BB5560E32D1A132637)

# random-quality
Framework for testing quality of random number generators

