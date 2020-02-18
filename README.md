# Introduction

There are many now quite venerable and newer test suites that will
check the quality of random number generators but none of them are
particularly easy to install and use:

  * [dieharder](http://webhome.phy.duke.edu/~rgb/General/dieharder.php "venerable")
  * [TestU01 (SmallCrush, Crush, BigCrush)](http://simul.iro.umontreal.ca/testu01/tu01.html "venerable")
  * [PractRand](http://pracrand.sourceforge.net/ "active")
  * [gjrand](http://gjrand.sourceforge.net/ "active")

This repo provides a <kbd>nix-shell</kbd> which will build
<kbd>dieharder</kbd>, <kbd>TestU01</kbd> and <kbd>PractRand</kbd> and
allow you (in the nix shell) to use them almost all identically with
the minimum amount of fuss.

In addition, this repo contains a Haskell program that will generate a
stream of random numbers from some of the Haskell random number
generator implementations.

# Instructions

* Clone the repo
  ```shell
  git clone https://github.com/tweag/random-quality.git
  cd random-quality
  nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/19.09.tar.gz
  ```

* Run a test
  ```shell
  generate random-word32 | RNG_test stdin32
  ```
  This uses the `random` library to generate a sequence of random numbers, and
  feeds them into `RNG_test`, which is PractRand's statistical randomness test
  binary. See [Generators](#generators) and [Tests](#tests) for details.

# Generators

The `generate` binary takes a single argument which determines the sequence of
random numbers that are written to stdout.

The form of the argument is `LIBRARY-TYPE[-SEQUENCE]`.

* `LIBRARY` is the Haskell library used,
* `TYPE` is the output type of the random number generator, and
* `SEQUENCE` is the sequence we use for generating the random number - we use
  this for stress-testing [`split`][hackage-random-split].

The test sequences (valid values for `SEQUENCE`) are:

* `split`, as described in section 5.5 of [Evaluation of splittable
  pseudo-random generators][doi-split-evaluation],
* `splitl`, `splitr` and `splita`, as described in section 5.6 of [Evaluation
  of splittable pseudo-random generators][doi-split-evaluation].

Generators using the [`random`][hackage-random] library:

* `random-int`
* `random-word32`
* `random-word32-split`
* `random-word32-splitl`
* `random-word32-splitr`
* `random-word32-splita`

Generators using the [`splitmix`][hackage-splitmix] library:

* `splitmix-word32`
* `splitmix-word32-split`
* `splitmix-word32-splitl`
* `splitmix-word32-splitr`
* `splitmix-word32-splita`

# Tests

The following randomness test suites are available in the repository via Nix,
all of which accept a stream of random numbers on stdin:

* [dieharder][]: run `dieharder -f stdin_input_raw -a` to execute all available
  tests (`-a`). See `dieharder -h` for more options.
* [PractRand][]: run via `RNG_test stdin32` to test a stream of 32-bit random
  numbers. See `RNG_test -help` for details.
* [TestU01][]: run via `TestU01_stdin -[s|c|b]`, which expects a stream of
  32-bit random numbers. Three test batteries are available: `-s` starts
  SmallCrush, `-c` starts Crush, `-b` starts BigCrush.
* [gjrand][]: run via `pmcp` to execute the standard test size (1 GB). See
  `pmcp -h` for options.

# Acknowledgements

[Peter Occil](https://github.com/peteroupc) for pointing out the
method for testing generators that support
[split](https://hackage.haskell.org/package/random-1.1/docs/System-Random.html#v:split)
method:

  * [Testing PRNGs for High-Quality Randomness][peteroupc-random-test]
  * [Evaluation of splittable pseudo-random generators][doi-split-evaluation]

[doi-split-evaluation]: https://doi.org/10.1017/S095679681500012X
[hackage-random]: https://hackage.haskell.org/package/random
[hackage-random-split]: https://hackage.haskell.org/package/random-1.1/docs/System-Random.html#v:split
[hackage-splitmix]: https://hackage.haskell.org/package/splitmix
[peteroupc-random-test]: https://github.com/peteroupc/peteroupc.github.io/blob/master/randomtest.md#testing-prngs-for-high-quality-randomness

[dieharder]: http://webhome.phy.duke.edu/~rgb/General/dieharder.php
[gjrand]: http://gjrand.sourceforge.net/
[practrand]: http://pracrand.sourceforge.net/
[testu01]: http://simul.iro.umontreal.ca/testu01/tu01.html
