# Erebine.ai Homebrew Tap

<div style="text-align: center;">
<img src="https://erebine.ai/erebine-ogimage.png" alt="Project Logo" width="50%">
</div>

A high-performance, accelerated intelligence platform.

This tap installs the prebuilt Erebine binaries: the `erectl` CLI, the
EIM inference agent, and the EEM execution agent. Formulas are pinned to
the latest stable release of
[Erebine/binaries](https://github.com/Erebine/binaries), and Homebrew
resolves the runtime library dependencies.

Each formula carries one block per platform, macOS arm64 and Linux x86_64,
and each block states the url, version and sha256 it actually installs. The
two platforms have not always been released together (v2.0.0 and v2.0.1
shipped Linux assets alone), so a block only moves to a release that carries
its asset and otherwise stays on the release it already names. `brew info
<formula>` reports the version your platform will get.

## Getting Started

``` shell
brew tap erebine/tap
brew install erectl
brew install erebine-eim-agent
brew install erebine-eem-agent
```

* The first command adds this tap.
* The next three commands install the binaries; Homebrew pulls in the
  `zeromq` and `zstd` libraries the agents link against.

Single-command form:

``` shell
brew install erebine/tap/erectl
```

## Packages

| Formula | Installs | Platform | Dependencies |
| --- | --- | --- | --- |
| `erectl` | `erectl` | macOS arm64, Linux x86_64 | zstd |
| `erebine-eim-agent` | `erebine-eim-agent` | macOS arm64, Linux x86_64 | zeromq, zstd |
| `erebine-eem-agent` | `erebine-eem-agent` | macOS arm64, Linux x86_64 | zeromq, zstd |

Documentation for running the binaries can be found in the
[docs](https://erebine.ai/docs/private-agents).

## Erebine Desktop

The `erebine-desktop` cask installs the Erebine Desktop app on macOS arm64
from the DMG a release carries. The DMG is built and signed on a Mac, so it
can lag the CI-built binaries; the cask is re-pinned only when the release
has one.

``` shell
brew install --cask erebine-desktop
```

## Updating formulas (maintainers)

After a new release of Erebine/binaries, run the "Pin formulas to release"
GitHub Actions workflow, which pins, checks and commits to `main`. Or do
the same by hand:

``` shell
scripts/update-formulas.sh          # or TAG=v2.2.1 scripts/update-formulas.sh
scripts/check-license.sh
git commit -am "pin formulas and cask to <version>"
```

The script resolves the latest stable tag, downloads each asset, and
rewrites the url, version and sha256 of the platform block that installs
it, in `Formula/` and `Casks/`. An asset that is missing from the release
is reported as a warning and its block is left untouched, so a partial
release cannot half-pin the tap. A rewrite that does not take, because a
formula's layout no longer matches what the script expects, fails the run
rather than committing a formula that names one build and installs another.
