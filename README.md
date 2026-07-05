# Erebine.ai Homebrew Tap

<div style="text-align: center;">
<img src="https://erebine.ai/erebine-ogimage.png" alt="Project Logo" width="50%">
</div>

A high-performance, accelerated intelligence platform.

This tap installs the prebuilt Erebine binaries: the `erectl` CLI, the
EIM inference agent, and the EEM execution agent. Formulas are pinned to
the latest stable release of
[Erebine/binaries](https://github.com/Erebine/binaries) (macOS Apple
Silicon and Linux x86_64), and Homebrew resolves the runtime library
dependencies.

## Getting Started

``` shell
brew tap erebine/tap
brew install erectl
brew install erebine-eim-agent
brew install erebine-eem-agent
brew install --cask erebine-desktop
```

* The first command adds this tap.
* The next three commands install the binaries; Homebrew pulls in the
  `zeromq` and `zstd` libraries the agents link against.
* The last command installs the Erebine Desktop app (Apple Silicon,
  macOS 15 or newer) from the notarized DMG.

Single-command form:

``` shell
brew install erebine/tap/erectl
```

## Packages

| Formula | Installs | Dependencies |
| --- | --- | --- |
| `erectl` | `erectl` | zstd |
| `erebine-eim-agent` | `erebine-eim-agent` | zeromq, zstd |
| `erebine-eem-agent` | `erebine-eem-agent` | zeromq, zstd |
| `erebine-desktop` (cask) | `Erebine.app` | none (DMG bundles its libraries) |

Documentation for running the binaries can be found in the
[docs](https://erebine.ai/docs/private-agents).

## Updating formulas (maintainers)

After a new release of Erebine/binaries:

``` shell
scripts/update-formulas.sh
git commit -am "pin formulas to <tag>"
```

The script resolves the latest stable tag, downloads each asset, and
rewrites the version, URLs, and sha256 checksums in `Formula/` and
`Casks/`.
