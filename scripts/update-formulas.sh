#!/bin/bash
# SPDX-License-Identifier: MIT
# Pin every formula and the cask to the latest stable Erebine/binaries release.
#
# Resolves the latest release tag, downloads each asset, and rewrites the
# url, version and sha256 in Formula/*.rb and Casks/*.rb. Run after each
# release, then commit the result.
#
# Each formula carries one block per platform (on_macos/on_arm and on_linux)
# and each block states its own url, version and sha256, because the two
# platforms have not always been released together: v2.0.0 and v2.0.1 shipped
# Linux x86_64 assets alone. Each block is therefore pinned on its own. A
# release that carries the Linux asset but not the Darwin one moves the
# Linux block and leaves the macOS block on the release it already names.
#
# Env:
#   TAG       release tag to pin (default: latest stable release)
#   GH_TOKEN  optional GitHub token for API/download requests
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
FORMULAE="$HERE/../Formula"
CASK="$HERE/../Casks/erebine-desktop.rb"
REPO="Erebine/binaries"

AUTH=()
[ -n "${GH_TOKEN:-}" ] && AUTH=(-H "Authorization: Bearer ${GH_TOKEN}")

if [ -z "${TAG:-}" ]; then
  TAG="$(curl -fsSL ${AUTH[@]+"${AUTH[@]}"} \
    "https://api.github.com/repos/${REPO}/releases/latest" \
    | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
fi
[ -n "$TAG" ] || { echo "could not resolve the latest release tag"; exit 1; }
VERSION="${TAG#v}"

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Finds the block of a formula or cask whose url downloads an asset named by
# MATCH_RE, and either rewrites it (mode=pin) or reports it (mode=read).
#
# The block is the run of stanzas around that url line, bounded by a `do`
# line, an `end` line, a `def`, the class line or another url. That is what
# makes it work whether the url comes before the version (formulas) or after
# it (the cask), at any indentation, and it is why the on_macos block is never
# touched when the on_linux block is pinned. Nothing here anchors on a fixed
# number of leading spaces: an expression that anchored on two spaces is how
# this script once moved every url to a new release while leaving every
# version and checksum behind, and still exited 0.
#
#   mode=pin   rewrites the url to URL and the block's version and sha256
#              to VERSION and SUM, and prints the whole file.
#   mode=read  prints "url|version|sha256" of the block, or "" if none.
BLOCK_AWK='
  function value(s) { match(s, /"[^"]*"/); return substr(s, RSTART + 1, RLENGTH - 2) }
  function basename(u,    n, parts) { n = split(u, parts, "/"); return parts[n] }
  function visit(i) {
    if (line[i] ~ /^[[:space:]]*version[[:space:]]+"/) {
      if (mode == "pin") sub(/"[^"]*"/, "\"" version "\"", line[i])
      got_version = value(line[i])
    }
    if (line[i] ~ /^[[:space:]]*sha256[[:space:]]+"/) {
      if (mode == "pin") sub(/"[^"]*"/, "\"" sum "\"", line[i])
      got_sha = value(line[i])
    }
  }
  { line[NR] = $0 }
  END {
    boundary = "^[[:space:]]*(url[[:space:]]|end([[:space:]]|$)|def[[:space:]]|class[[:space:]])|[[:space:]]do[[:space:]]*$"
    hit = 0
    for (i = 1; i <= NR; i++)
      if (line[i] ~ /^[[:space:]]*url[[:space:]]+"/ && basename(value(line[i])) ~ match_re) hit = i
    if (hit) {
      if (mode == "pin") sub(/"[^"]*"/, "\"" url "\"", line[hit])
      for (i = hit - 1; i >= 1 && line[i] !~ boundary; i--) visit(i)
      for (i = hit + 1; i <= NR && line[i] !~ boundary; i++) visit(i)
    }
    if (mode == "read") { if (hit) print value(line[hit]) "|" got_version "|" got_sha; else print "" }
    else for (i = 1; i <= NR; i++) print line[i]
  }'

# Downloads ASSET from the release and pins the block of FILE whose url names
# it, then reads the block back and fails if it does not say exactly what was
# written. A missing asset warns and leaves the block untouched, so a release
# that is still uploading, or that carries one platform only, can never leave
# a block half-pinned to a checksum that was never computed.
#   pin FILE MATCH_RE ASSET
pin() {
  local file="$1" match_re="$2" asset="$3" url sum got
  url="https://github.com/${REPO}/releases/download/${TAG}/${asset}"
  if ! curl -fsSL ${AUTH[@]+"${AUTH[@]}"} -o "$TMP/$asset" "$url"; then
    echo "    WARN: ${asset} not in ${TAG}; its block in ${file##*/} is left as is"
    return 0
  fi
  sum="$(sha256 "$TMP/$asset")"
  awk -v mode=pin -v match_re="$match_re" -v url="$url" \
      -v version="$VERSION" -v sum="$sum" "$BLOCK_AWK" "$file" > "$TMP/rewrite"
  cat "$TMP/rewrite" > "$file"
  got="$(awk -v mode=read -v match_re="$match_re" "$BLOCK_AWK" "$file")"
  if [ "$got" != "${url}|${VERSION}|${sum}" ]; then
    echo "ERROR: ${file##*/}: the block whose url matches ${match_re} was not pinned." >&2
    echo "       wanted: ${url}|${VERSION}|${sum}" >&2
    echo "       found:  ${got:-no such block}" >&2
    echo "       The file no longer has the layout this script rewrites; fix one or the other." >&2
    exit 1
  fi
  echo "    ${asset}: ${sum}"
}

for name in erectl erebine-eim-agent erebine-eem-agent; do
  echo "==> ${name} (${TAG})"
  for asset in "${name}-Darwin-arm64" "${name}-Linux-x86_64"; do
    pin "$FORMULAE/${name}.rb" "^${asset}\$" "$asset"
  done
done

# The DMG is built and signed on a Mac, so it can lag the CI-built binaries
# or be missing from a release cut on a Linux host alone (v2.0.0 and v2.0.1
# carry none; v2.0.2 onwards do). Its file name carries the full tag
# (Erebine-Desktop-v2.2.1.dmg), not the bare version, so the block is found
# by the name's shape rather than by the name itself.
echo "==> erebine-desktop cask (${TAG})"
pin "$CASK" '^Erebine-Desktop-.*[.]dmg$' "Erebine-Desktop-${TAG}.dmg"

# Tell a GitHub Actions caller which tag was pinned, so the commit can name it.
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "tag=${TAG}" >> "$GITHUB_OUTPUT"
fi

echo "==> done (${TAG}); check the warnings above, then review and commit Formula/ and Casks/"
