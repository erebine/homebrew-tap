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

**The two platforms are on different releases.** Linux x86_64 installs
v2.0.0. macOS arm64 installs v1.10.0, because Erebine/binaries has shipped
Linux x86_64 assets alone since v1.10.2 and v1.10.0 is the last release
that carried a Darwin build. Each platform block therefore states the
version it actually installs, rather than one version standing for both.

macOS returns to the current release as soon as a release publishes Darwin
assets again; only the url, version and sha256 in the `on_macos` block move.

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
| `erectl` | `erectl` | Linux x86_64 | zstd |
| `erebine-eim-agent` | `erebine-eim-agent` | Linux x86_64 | zeromq, zstd |
| `erebine-eem-agent` | `erebine-eem-agent` | Linux x86_64 | zeromq, zstd |

Documentation for running the binaries can be found in the
[docs](https://erebine.ai/docs/private-agents).

## Erebine Desktop (deprecated)

The `erebine-desktop` cask is deprecated. The last release carrying a
DMG was v1.10.1; nothing has shipped since. The cask stays pinned to that
build so existing installs keep working, and `brew install --cask
erebine-desktop` prints a deprecation warning.

``` shell
brew install --cask erebine-desktop   # deprecated, installs v1.10.1
```

## Updating formulas (maintainers)

After a new release of Erebine/binaries:

``` shell
scripts/update-formulas.sh
git commit -am "pin formulas to <tag>"
```

The script resolves the latest stable tag, downloads each asset, and
rewrites the version, URLs, and sha256 checksums in `Formula/`. An asset
that is missing from the release is reported as a warning and its formula
is left untouched, so a partial release cannot half-pin the tap. The cask
is re-pinned only if a release carries a DMG again.
