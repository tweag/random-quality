# generate

`generate` is a Haskell binary. The easiest way to build it is to enter the
environment provided in this repository using the following command:

```shell
nix-shell https://github.com/tweag/random-quality/archive/master.tar.gz \
    --arg buildHaskell true
```

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
* `random-double`
* `random-word32`
* `random-word32-split`
* `random-word32-splitl`
* `random-word32-splitr`
* `random-word32-splita`

Generators using the [`splitmix`][hackage-splitmix] library:

* `splitmix-double`
* `splitmix-word32`
* `splitmix-word32-split`
* `splitmix-word32-splitl`
* `splitmix-word32-splitr`
* `splitmix-word32-splita`

# Acknowledgements

[Peter Occil](https://github.com/peteroupc) for pointing out the
method for testing generators that support
[split](https://hackage.haskell.org/package/random-1.1/docs/System-Random.html#v:split)
method:

  * [Testing PRNGs for High-Quality Randomness][peteroupc-random-test]
  * [Evaluation of splittable pseudo-random generators][doi-split-evaluation]

[doi-split-evaluation]: https://doi.org/10.1017/S095679681500012X
[peteroupc-random-test]: https://github.com/peteroupc/peteroupc.github.io/blob/master/randomtest.md#testing-prngs-for-high-quality-randomness

[hackage-random]: https://hackage.haskell.org/package/random
[hackage-random-split]: https://hackage.haskell.org/package/random-1.1/docs/System-Random.html#v:split
[hackage-splitmix]: https://hackage.haskell.org/package/splitmix
