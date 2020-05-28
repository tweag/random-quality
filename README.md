# random-quality

There are many now quite venerable and newer test suites that will
check the quality of random number generators but none of them are
particularly easy to install and use:

  * [dieharder](http://webhome.phy.duke.edu/~rgb/General/dieharder.php "venerable")
  * [TestU01 (SmallCrush, Crush, BigCrush)](http://simul.iro.umontreal.ca/testu01/tu01.html "venerable")
  * [PractRand](http://pracrand.sourceforge.net/ "active")
  * [gjrand](http://gjrand.sourceforge.net/ "active")
  * [rademacher-fpl](https://gitlab.com/christoph-conrads/rademacher-fpl/-/tree/master "active")

This repo provides a <kbd>nix-shell</kbd> which will build
<kbd>dieharder</kbd>, <kbd>TestU01</kbd> and <kbd>PractRand</kbd> and
allow you (in the nix shell) to use them almost all identically with
the minimum amount of fuss.

Optionally, this repo contains a Haskell program that will generate a
stream of random numbers from some of the Haskell random number
generator implementations. See [generate/README.md](generate/README.md) for
details.

# Setup

* Enter the test environment containing only the PRNG test batteries:
  ```shell
  nix-shell https://github.com/tweag/random-quality/archive/master.tar.gz
  ```
  To test that the environment is set up correctly, run:
  ```shell
  RNG_test stdin32 < /dev/zero
  ```
  This should show a spectacularly failed test: `/dev/zero` is not a good PRNG.
  See [Tests](#tests) for details.

* Alternatively, enter the test environment containing the PRNG test batteries
  as well as a number of Haskell PRNGs:
  ```shell
  nix-shell https://github.com/tweag/random-quality/archive/master.tar.gz \
      --arg buildHaskell true
  ```
  To test that the environment is set up correctly, run:
  ```shell
  generate random-word32 | RNG_test stdin32
  ```
  The whole test takes a long time, you can cancel it with <kbd>Ctrl+C</kbd>.
  This uses the `random` library to generate a sequence of random numbers. See
  [Generators](generate/README.md#generators) and [Tests](#tests) for details.

# Tests

The following randomness test suites are available in the repository via Nix,
all of which accept a stream of random numbers on stdin:

* [dieharder][]: run `dieharder -a -g200` to execute all available tests
  (`-a`). See `dieharder -h` for more options.
* [PractRand][]: run via `RNG_test stdin32` to test a stream of 32-bit random
  numbers. See `RNG_test -help` for details.
* [TestU01][]: run via `TestU01_stdin -[s|c|b]`, which expects a stream of
  32-bit random numbers. Three test batteries are available: `-s` starts
  SmallCrush, `-c` starts Crush, `-b` starts BigCrush.
* [gjrand][]: run via `pmcp` to execute the standard test size (1 GB) on ints,
  and `pmcpf` to test double precision floating point numbers. See `pmcp -h`
  and `pmcpf -h` for options.
* [rademacher-fpl][]: run via `detect-significand-bias` to execute the standard
  test size (10 MB) on double precision floating point numbers.

[dieharder]: http://webhome.phy.duke.edu/~rgb/General/dieharder.php
[gjrand]: http://gjrand.sourceforge.net/
[practrand]: http://pracrand.sourceforge.net/
[rademacher-fpl]: https://gitlab.com/christoph-conrads/rademacher-fpl/-/tree/master
[testu01]: http://simul.iro.umontreal.ca/testu01/tu01.html
