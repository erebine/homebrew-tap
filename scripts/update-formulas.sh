#!/bin/bash
# SPDX-License-Identifier: MIT
# Pin every formula to the latest stable Erebine/binaries release.
#
# Resolves the latest release tag, downloads each formula's assets,
# and rewrites the version, download URLs, and sha256 checksums in
# Formula/*.rb. Run after each release, then commit the result.
#
# Env:
#   TAG       release tag to pin (default: latest stable release)
#   GH_TOKEN  optional GitHub token for API/download requests
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
FORMULAE="$HERE/../Formula"
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

# GNU and BSD sed disagree on -i; wrap it.
sedi() {
  if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi
}

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

for name in erectl erebine-eim-agent erebine-eem-agent; do
  formula="$FORMULAE/${name}.rb"
  echo "==> ${name} (${TAG})"
  sedi "s/^  version \".*\"/  version \"${VERSION}\"/" "$formula"
  sedi "s|/releases/download/[^/]*/|/releases/download/${TAG}/|g" "$formula"
  for asset in "${name}-Darwin-arm64" "${name}-Linux-x86_64"; do
    curl -fSL ${AUTH[@]+"${AUTH[@]}"} -o "$TMP/$asset" \
      "https://github.com/${REPO}/releases/download/${TAG}/${asset}"
    sum="$(sha256 "$TMP/$asset")"
    # Replace the sha256 line that follows this asset's url line.
    sedi "\\|${asset}\"|{n;s|sha256 \".*\"|sha256 \"${sum}\"|;}" "$formula"
    echo "    ${asset}: ${sum}"
  done
done

CASK="$HERE/../Casks/erebine-desktop.rb"
echo "==> erebine-desktop cask (${TAG})"
# The DMG is signed and uploaded from a mac, so it can lag the CI-built
# binaries; pin the cask only when the asset exists. The DMG file name
# carries the full tag (Erebine-Desktop-v0.0.1.dmg), not the bare version.
if curl -fSL ${AUTH[@]+"${AUTH[@]}"} -o "$TMP/Erebine-Desktop.dmg" \
  "https://github.com/${REPO}/releases/download/${TAG}/Erebine-Desktop-${TAG}.dmg"; then
  sedi "s/^  version \".*\"/  version \"${VERSION}\"/" "$CASK"
  sedi "s|/releases/download/[^/]*/|/releases/download/${TAG}/|g" "$CASK"
  sedi "s|Erebine-Desktop-[^\"]*\.dmg|Erebine-Desktop-${TAG}.dmg|" "$CASK"
  sum="$(sha256 "$TMP/Erebine-Desktop.dmg")"
  sedi "s|^  sha256 \".*\"|  sha256 \"${sum}\"|" "$CASK"
  echo "    Erebine-Desktop-${TAG}.dmg: ${sum}"
else
  echo "    WARN: Erebine-Desktop-${TAG}.dmg not in ${TAG}; cask left unpinned"
fi

echo "==> formulas and cask pinned to ${TAG}; review and commit Formula/ and Casks/"
