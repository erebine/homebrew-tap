# Erebine.ai Homebrew Tap

<div style="text-align: center;">
<img src="https://erebine.ai/erebine-ogimage.png" alt="Project Logo" width="50%">
</div>

A high-performance, accelerated intelligence platform.

This tap installs the prebuilt Erebine binaries: the `erectl` CLI, the
Erebine Inference Microservice (EIM), and the Erebine Execution Manager
(EEM). Formulas are pinned to the latest stable release of
[Erebine/binaries](https://github.com/Erebine/binaries), and Homebrew
resolves the runtime library dependencies.

Each formula carries one block per platform, macOS arm64, Linux x86_64 and
Linux aarch64, and each block states the url, version and sha256 it actually
installs. The platforms have not always been released together (v2.0.0 and
v2.0.1 shipped Linux x86_64 assets alone, and Linux aarch64 builds start at
v2.10.0), so a block only moves to a release that carries its asset and
otherwise stays on the release it already names. `brew info <formula>`
reports the version your platform will get.

## Getting Started

``` shell
brew tap erebine/tap
brew install erectl
brew install erebine-eim
brew install erebine-eem
```

* The first command adds this tap.
* The next three commands install the binaries; Homebrew pulls in the
  `zeromq` and `zstd` libraries the EIM and EEM link against.

Single-command form:

``` shell
brew install erebine/tap/erectl
```

## Packages

| Formula | Installs | Platform | Dependencies |
| --- | --- | --- | --- |
| `erectl` | `erectl` | macOS arm64, Linux x86_64 and aarch64 | zstd |
| `erebine-eim` | `erebine-eim`, linked as `erebine-eim-agent` | macOS arm64, Linux x86_64 and aarch64 | zeromq, zstd |
| `erebine-eem` | `erebine-eem`, linked as `erebine-eem-agent` | macOS arm64, Linux x86_64 and aarch64 | zeromq, zstd |

The EIM and EEM formulas were `erebine-eim-agent` and `erebine-eem-agent`
before 2.10. Those names are now renames, listed in `formula_renames.json`:
`brew install erebine-eim-agent` installs `erebine-eim`, and an existing
`erebine-eim-agent` or `erebine-eem-agent` install is migrated to the new
name by the next `brew update` or `brew upgrade`. Each formula also links
its binary's old name to the new one, so scripts and service units that run
`erebine-eim-agent` or `erebine-eem-agent` keep working.

Documentation for running the binaries can be found in the
[docs](https://erebine.ai/docs/private-agents).

## Erebine app

The `erebine-desktop` cask installs the Erebine app (`Erebine.app`) from the
DMG a release carries. It needs macOS 26 (Tahoe) or later on Apple silicon.
The DMG is built and signed on a Mac, so it can lag the CI-built binaries;
the cask is re-pinned only when the release has one.

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

A block for a platform no release has carried yet names the first release
expected to carry it, with a sha256 of 64 zeros (Linux aarch64 until
v2.10.0). `scripts/check-license.sh` reports it as not pinned, and fails,
until a pin against a release that carries the asset rewrites it.
