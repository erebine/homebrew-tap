#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
#
# check-license.sh -- fail when a formula stops stating the license of the
# binary it installs, or states it for a different build than it downloads.
#
# Why this exists
# ---------------
# A tap is a licensing surface. `brew info --json` reports the `license`
# stanza, and package mirrors and audit tools read it; a formula with no
# stanza, or one naming terms the binaries are not under, is the tap making a
# false statement about someone else's software. Erebine's licensing model
# distributes the erectl, EIM and EEM binaries as MIT-licensed, so MIT must be
# part of what every formula declares.
#
# The second failure is subtler and is built into how this tap is maintained.
# scripts/update-formulas.sh rewrites `version`, `url` and `sha256` with three
# separate sed expressions, and skips a formula whose asset is missing from
# the release -- printing a warning and moving on. A formula can therefore end
# up declaring one version while downloading another, or sit a release behind
# its siblings. The license stanza is then attached to a build it does not
# describe, and the checksum vouches for a file the version does not name.
#
# What this deliberately does NOT do
# ----------------------------------
# It resolves nothing over the network: no release, no tag, no checksum
# verification. Every invariant here is an agreement between lines of the same
# file, or between files in this repository. A check that asked GitHub whether
# the pinned tag exists would fail for reasons that have nothing to do with
# this repository, and would gate every pull request on the release process.
#
# The cask is checked for version/URL agreement only. Homebrew's cask DSL has
# no `license` stanza, so there is nothing there to state.
#
# Usage
# -----
#   scripts/check-license.sh              # check the repository
#   scripts/check-license.sh --self-test  # run against fixtures
#
# Exit status: 0 pass, 1 check failed, 2 usage error.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# The only place a formula may download from. Anywhere else is not a build
# whose license this tap knows.
ASSET_PREFIX="https://github.com/Erebine/binaries/releases/download/"

# The license identifier the Erebine binaries are distributed under. A
# formula may name more than this -- Homebrew's all_of: form is how a
# statically linked binary states its dependencies' terms too -- but MIT is
# Erebine's own grant and may not disappear.
REQUIRED_LICENSE="MIT"

# Reads the value of a single-quoted-or-double-quoted stanza from a formula.
#   stanza_value FILE NAME
stanza_value() {
  sed -n "s/^[[:space:]]*$2[[:space:]]\+\"\([^\"]*\)\".*/\1/p" "$1" | head -1
}

# Checks one formula or cask file. WANT_LICENSE is 1 for formulas, 0 for
# casks. Prints one line per finding and returns 0 when all of them pass.
#   check_ruby_file ROOT PATH WANT_LICENSE
check_ruby_file() {
  local root="$1" path="$2" want_license="$3" rel="${2#"$1"/}" failed=0
  local version url sha tag

  if ! grep -q '^# SPDX-License-Identifier:' "$path"; then
    echo "FAIL $rel: no SPDX-License-Identifier header"
    failed=1
  fi

  if [ "$want_license" -eq 1 ]; then
    local license_line
    license_line="$(grep -m1 '^[[:space:]]*license[[:space:]]' "$path" || true)"
    if [ -z "$license_line" ]; then
      echo "FAIL $rel: no license stanza"
      echo "     brew info reports this stanza; without it the tap states nothing."
      failed=1
    elif printf '%s' "$license_line" | grep -qF "$REQUIRED_LICENSE"; then
      echo "ok   $rel: license stanza names $REQUIRED_LICENSE"
    else
      echo "FAIL $rel: license stanza does not name $REQUIRED_LICENSE"
      echo "    $license_line"
      echo "     The Erebine binaries are distributed as MIT-licensed."
      failed=1
    fi
  fi

  version="$(stanza_value "$path" version)"
  url="$(stanza_value "$path" url)"
  sha="$(stanza_value "$path" sha256)"

  if [ -z "$version" ]; then
    echo "FAIL $rel: no version stanza"
    failed=1
  fi
  if [ -z "$url" ]; then
    echo "FAIL $rel: no url stanza"
    failed=1
    return "$failed"
  fi

  case "$url" in
    "$ASSET_PREFIX"*) ;;
    *)
      echo "FAIL $rel: url does not download from $ASSET_PREFIX"
      echo "     $url"
      failed=1
      return "$failed" ;;
  esac

  # .../releases/download/<tag>/<asset>
  tag="${url#"$ASSET_PREFIX"}"
  tag="${tag%%/*}"
  if [ -n "$version" ] && [ "$tag" != "v$version" ]; then
    echo "FAIL $rel: version \"$version\" but url downloads from tag $tag"
    echo "     The license and checksum then describe a different build."
    failed=1
  elif [ -n "$version" ]; then
    echo "ok   $rel: version $version agrees with tag $tag"
  fi

  if ! printf '%s' "$sha" | grep -qE '^[0-9a-f]{64}$'; then
    echo "FAIL $rel: sha256 is not 64 lowercase hex digits"
    echo "     \"$sha\""
    failed=1
  fi

  if LC_ALL=C grep -q '[^[:print:][:space:]]' "$path"; then
    echo "FAIL $rel: non-ASCII bytes"
    failed=1
  fi

  return "$failed"
}

# Runs every check under ROOT. Prints one line per check and returns 0 when
# all of them pass.
check_tree() {
  local root="$1" failed=0 file versions="" version

  if [ -s "$root/LICENSE" ]; then
    echo "ok   LICENSE: present and non-empty"
  else
    echo "FAIL LICENSE: missing or empty"
    failed=1
  fi

  if ! compgen -G "$root/Formula/*.rb" >/dev/null; then
    echo "FAIL Formula/: no formulas found"
    return 1
  fi

  for file in "$root"/Formula/*.rb; do
    check_ruby_file "$root" "$file" 1 || failed=1
    version="$(stanza_value "$file" version)"
    versions="$versions$version"$'\n'
  done

  # update-formulas.sh leaves a formula untouched when its asset is missing
  # from the release, so the formulas can silently end up on two versions.
  local distinct
  distinct="$(printf '%s' "$versions" | grep -v '^$' | sort -u | paste -sd' ' -)"
  if [ "$(printf '%s' "$versions" | grep -cv '^$')" -gt 0 ] &&
     [ "$(printf '%s' "$versions" | grep -v '^$' | sort -u | wc -l)" -ne 1 ]; then
    echo "FAIL Formula/: formulas are pinned to different versions: $distinct"
    echo "     A partial pin leaves one formula's license attached to an"
    echo "     older build than its siblings."
    failed=1
  else
    echo "ok   Formula/: every formula is pinned to the same version ($distinct)"
  fi

  # Casks carry no license stanza; only the version/URL agreement is checked.
  if compgen -G "$root/Casks/*.rb" >/dev/null; then
    for file in "$root"/Casks/*.rb; do
      check_ruby_file "$root" "$file" 0 || failed=1
    done
  fi

  return "$failed"
}

# Builds fixture trees and proves the check fails on a missing license
# stanza, a license that is not MIT, a version that disagrees with its URL, a
# partial pin, a foreign download host, a placeholder checksum, a missing
# SPDX header and a non-ASCII byte.
self_test() {
  local tmp status=0 case_name
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN

  local good="$tmp/good"
  mkdir -p "$good/Formula" "$good/Casks"
  printf 'MIT License\n' >"$good/LICENSE"
  local name
  for name in erectl erebine-eim-agent; do
    cat >"$good/Formula/$name.rb" <<RB
# SPDX-License-Identifier: MIT
class Placeholder < Formula
  desc "Erebine"
  homepage "https://erebine.ai"
  url "${ASSET_PREFIX}v1.13.0/${name}-Linux-x86_64"
  version "1.13.0"
  sha256 "59d8df8f74d5bdfaa57b236a4cbea8e6a7b9d0d934b2df22f7ae01b5aad84a2c"
  license "MIT"
end
RB
  done
  cat >"$good/Casks/erebine-desktop.rb" <<RB
# SPDX-License-Identifier: MIT
cask "erebine-desktop" do
  version "1.10.1"
  sha256 "c43f26ba9189f3ab62f6e55537020e6164905d19d5c60eb7062624766662c111"
  url "${ASSET_PREFIX}v1.10.1/Erebine-Desktop-v1.10.1.dmg"
end
RB

  if check_tree "$good" >/dev/null; then
    echo "self-test ok   formulas at one version, and a cask pinned elsewhere, pass"
  else
    echo "self-test FAIL the good fixture should pass"
    check_tree "$good" || true
    status=1
  fi

  for case_name in no-license-stanza non-mit-license version-url-mismatch \
                   partial-pin foreign-host placeholder-sha no-spdx-header non-ascii; do
    local bad="$tmp/$case_name"
    cp -r "$good" "$bad"
    local f="$bad/Formula/erectl.rb"
    case "$case_name" in
      no-license-stanza)   sed -i '/^  license /d' "$f" ;;
      non-mit-license)     sed -i 's/license "MIT"/license "GPL-3.0-only"/' "$f" ;;
      version-url-mismatch) sed -i 's|/v1.13.0/|/v1.10.2/|' "$f" ;;
      partial-pin)
        sed -i -e 's/version "1.13.0"/version "1.10.2"/' -e 's|/v1.13.0/|/v1.10.2/|' "$f" ;;
      foreign-host)
        sed -i 's|https://github.com/Erebine/binaries|https://example.invalid/mirror|' "$f" ;;
      placeholder-sha)     sed -i 's/^  sha256 ".*"/  sha256 "TODO"/' "$f" ;;
      no-spdx-header)      sed -i '1d' "$f" ;;
      non-ascii)           printf '# Copyright \302\251 2026\n' >>"$f" ;;
    esac
    if check_tree "$bad" >/dev/null 2>&1; then
      echo "self-test FAIL $case_name should fail"
      status=1
    else
      echo "self-test ok   $case_name fails"
    fi
  done
  return "$status"
}

case "${1:-}" in
  "") check_tree "$REPO_ROOT" ;;
  --self-test) self_test ;;
  *) echo "usage: $0 [--self-test]" >&2; exit 2 ;;
esac
