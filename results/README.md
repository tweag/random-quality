# Test results

This folder contains test results. Each result file contains the command run as
well as the commit hash of this repository from which it was run, to get
maximum reproducibility.

- **`random`** in the results refers to [`random` v1.1][random-1.1]
- **`splitmix`** refers to [`splitmix`][splitmix]

Since [`random` v1.2][random-1.1] uses `splitmix` as its generator, the results
for `splitmix` directly translate into results for `random` v1.2.

[random-1.1]: https://hackage.haskell.org/package/random-1.1
[random-1.2]: https://github.com/haskell/random/pull/61
[splitmix]: https://hackage.haskell.org/package/splitmix-0.0.4
