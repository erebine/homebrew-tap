# Xerotier.ai Homebrew Tap

<div style="text-align: center;">
<img src="https://xerotier.ai/xerotier-ogimage.png" alt="Project Logo" width="50%">
</div>

A high-performance, accelerated intelligence platform.

This tap installs the prebuilt Xerotier binaries: the `xeroctl` CLI, the
XIM inference agent, and the XEM execution agent. Formulas are pinned to
the latest stable release of
[Xerotier/binaries](https://github.com/Xerotier/binaries) (macOS Apple
Silicon and Linux x86_64), and Homebrew resolves the runtime library
dependencies.

## Getting Started

``` shell
brew tap xerotier/tap
brew install xeroctl
brew install xerotier-xim-agent
brew install xerotier-xem-agent
```

* The first command adds this tap.
* The remaining commands install the binaries; Homebrew pulls in the
  `zeromq` and `zstd` libraries the agents link against.

Single-command form:

``` shell
brew install xerotier/tap/xeroctl
```

## Packages

| Formula | Binary | Dependencies |
| --- | --- | --- |
| `xeroctl` | `xeroctl` | zstd |
| `xerotier-xim-agent` | `xerotier-xim-agent` | zeromq, zstd |
| `xerotier-xem-agent` | `xerotier-xem-agent` | zeromq, zstd |

Documentation for running the binaries can be found in the
[docs](https://xerotier.ai/docs/private-agents).

## Updating formulas (maintainers)

After a new release of Xerotier/binaries:

``` shell
scripts/update-formulas.sh
git commit -am "pin formulas to <tag>"
```

The script resolves the latest stable tag, downloads each asset, and
rewrites the version, URLs, and sha256 checksums in `Formula/`.
