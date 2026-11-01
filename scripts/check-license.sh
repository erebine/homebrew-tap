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
# A formula carries one block per platform (macOS arm64, Linux x86_64, Linux
# aarch64), and update-formulas.sh pins each block on its own. So every check
# of url, version and sha256 is made per block, and the version agreement
# between formulas is made per platform. A formula block states no version:
# Homebrew reads it from the release tag in the url, so the tag is the
# version compared across formulas. A block that does state one (the cask,
# whose url interpolates #{version}) must agree with the tag its url resolves
# to. A block for a platform no release has carried yet holds a sha256 of 64
# zeros; it is reported as not pinned until update-formulas.sh pins it.
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

# The sha256 a block carries until update-formulas.sh first pins it.
UNPINNED_SHA="0000000000000000000000000000000000000000000000000000000000000000"

# Prints "url|version|sha256" for every block of a formula or cask that
# names any of the three. A block is the run of stanzas between a `do` line,
# an `end` line, a `def`, the class line or a second url: the same block
# scripts/update-formulas.sh rewrites, so what is checked here is what it
# pins. A formula writes url before version, a cask writes version and
# sha256 before url; either order is one block, and a value is never
# borrowed by the next block.
#   blocks FILE
blocks() {
  awk '
    function value(s) { match(s, /"[^"]*"/); return substr(s, RSTART + 1, RLENGTH - 2) }
    function flush() {
      if (u != "" || v != "" || s != "") print u "|" v "|" s
      u = ""; v = ""; s = ""
    }
    /^[[:space:]]*url[[:space:]]+"/ { if (u != "") flush(); u = value($0); next }
    /^[[:space:]]*version[[:space:]]+"/ { v = value($0); next }
    /^[[:space:]]*sha256[[:space:]]+"/ { s = value($0); next }
    /^[[:space:]]*(end([[:space:]]|$)|def[[:space:]]|class[[:space:]])|[[:space:]]do[[:space:]]*$/ { flush() }
    END { flush() }
  ' "$1"
}

# The platform a release asset is built for: the last two dash-separated
# fields of its name (erebine-eim-Linux-aarch64 -> Linux-aarch64).
#   platform_of URL
platform_of() {
  local asset="${1##*/}" rest
  rest="${asset%-*}"
  printf '%s-%s\n' "${rest##*-}" "${asset##*-}"
}

# Checks one formula or cask file. WANT_LICENSE is 1 for formulas, 0 for
# casks. Prints one line per finding and returns 0 when all of them pass.
#   check_ruby_file ROOT PATH WANT_LICENSE
check_ruby_file() {
  local root="$1" path="$2" want_license="$3" rel="${2#"$1"/}" failed=0

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

  # .../releases/download/<tag>/<asset>, for EVERY block in the file.
  #
  # A formula carries one url per platform, each in its own block with its
  # own version and sha256, because the platforms are not always released
  # together. Reading only the first block would check one platform and
  # silently pass whatever the others say -- which is worse than failing,
  # because the build goes green while a url nobody looked at points at a
  # release that may not exist.
  local url version sha tag blocks_seen=0 url_shas=""
  while IFS='|' read -r url version sha; do
    [ -n "$url$version$sha" ] || continue
    blocks_seen=$((blocks_seen + 1))
    url_shas="$url_shas$url $sha"$'\n'
    if [ -z "$url" ]; then
      echo "FAIL $rel: a block states a version or sha256 but no url"
      failed=1
      continue
    fi
    case "$url" in
      "$ASSET_PREFIX"*) ;;
      *)
        echo "FAIL $rel: url does not download from $ASSET_PREFIX"
        echo "     $url"
        failed=1
        continue ;;
    esac
    if [[ "$url" == *'#{version}'* ]]; then
      if [ -z "$version" ]; then
        echo "FAIL $rel: url interpolates #{version} but its block states no version"
        failed=1
        continue
      fi
      url="${url//'#{version}'/$version}"
    fi
    tag="${url#"$ASSET_PREFIX"}"
    tag="${tag%%/*}"
    if [ -z "$version" ]; then
      echo "ok   $rel: version ${tag#v} from tag $tag"
    elif [ "$tag" != "v$version" ]; then
      echo "FAIL $rel: version \"$version\" but url downloads from tag $tag"
      echo "     The license and checksum then describe a different build."
      failed=1
    else
      echo "ok   $rel: version $version agrees with tag $tag"
    fi
    if [ "$sha" = "$UNPINNED_SHA" ]; then
      echo "FAIL $rel: ${url##*/} is not pinned yet (sha256 is the zero placeholder)"
      echo "     Run scripts/update-formulas.sh against a release that carries it."
      failed=1
    elif ! printf '%s' "$sha" | grep -qE '^[0-9a-f]{64}$'; then
      echo "FAIL $rel: ${url##*/}: sha256 is not 64 lowercase hex digits"
      echo "     \"$sha\""
      failed=1
    fi
  done <<EOF2
$(blocks "$path")
EOF2
  if [ "$blocks_seen" -eq 0 ]; then
    echo "FAIL $rel: no url stanza found"
    failed=1
  fi

  # Two blocks may download the same asset (the macOS on_intel block repeats
  # the on_arm one so an Intel Mac reaches the arm64 requirement); they must
  # then vouch for it with the same checksum.
  local split_url
  for split_url in $(printf '%s' "$url_shas" |
                     awk 'NF { if (($1 in s) && s[$1] != $2) print $1; s[$1] = $2 }' | sort -u); do
    echo "FAIL $rel: blocks that download ${split_url##*/} disagree on its sha256"
    failed=1
  done

  if LC_ALL=C grep -q '[^[:print:][:space:]]' "$path"; then
    echo "FAIL $rel: non-ASCII bytes"
    failed=1
  fi

  return "$failed"
}

# Runs every check under ROOT. Prints one line per check and returns 0 when
# all of them pass.
check_tree() {
  local root="$1" failed=0 file pins="" url version

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
    while IFS='|' read -r url version _; do
      # A url from elsewhere is already reported above; it has no tag here.
      case "$url" in "$ASSET_PREFIX"*) ;; *) continue ;; esac
      if [ -z "$version" ]; then
        version="${url#"$ASSET_PREFIX"}"
        version="${version%%/*}"
        version="${version#v}"
      fi
      pins="$pins$(platform_of "$url") $version"$'\n'
    done <<EOF
$(blocks "$file")
EOF
  done

  # update-formulas.sh leaves a block untouched when its asset is missing
  # from the release, so the formulas can silently end up on two versions.
  # The platforms may differ (a release can carry Linux assets alone), but
  # every formula's block for one platform must name the same release.
  local platform distinct
  for platform in $(printf '%s' "$pins" | awk 'NF { print $1 }' | sort -u); do
    distinct="$(printf '%s' "$pins" | awk -v p="$platform" '$1 == p { print $2 }' |
      sort -u | paste -sd' ' -)"
    if [ "$(printf '%s\n' "$distinct" | wc -w)" -ne 1 ]; then
      echo "FAIL Formula/: the $platform blocks are pinned to different versions: $distinct"
      echo "     A partial pin leaves one formula's license attached to an"
      echo "     older build than its siblings."
      failed=1
    else
      echo "ok   Formula/: every $platform block is pinned to the same version ($distinct)"
    fi
  done

  # Casks carry no license stanza; only the version/URL agreement is checked.
  if compgen -G "$root/Casks/*.rb" >/dev/null; then
    for file in "$root"/Casks/*.rb; do
      check_ruby_file "$root" "$file" 0 || failed=1
    done
  fi

  return "$failed"
}

# Builds fixture trees and proves the check fails on a missing license
# stanza, a license that is not MIT, a cask version that disagrees with its
# URL, a cask URL that interpolates a version it does not state, a partial
# pin, a foreign download host, a placeholder checksum, a missing SPDX header
# and a non-ASCII byte, and that the url, version and checksum checks reach a
# formula's last platform block, not only its first, and that the macOS
# on_intel block that repeats the on_arm one moves and vouches with it. The
# formulas state no version, as in the tap; the cask interpolates its own.
self_test() {
  local tmp status=0 case_name
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN

  # The macOS blocks sit a release behind the Linux ones, as after a release
  # that carried Linux assets alone: that is a valid pin.
  local good="$tmp/good"
  mkdir -p "$good/Formula" "$good/Casks"
  printf 'MIT License\n' >"$good/LICENSE"
  local name
  for name in erectl erebine-eim; do
    cat >"$good/Formula/$name.rb" <<RB
# SPDX-License-Identifier: MIT
class Placeholder < Formula
  desc "Erebine"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "${ASSET_PREFIX}v1.12.0/${name}-Darwin-arm64"
      sha256 "8a6e4b0c56d9f0e4f3c1b2a7d5e6f8091a2b3c4d5e6f708192a3b4c5d6e7f809"
    end
    on_intel do
      url "${ASSET_PREFIX}v1.12.0/${name}-Darwin-arm64"
      sha256 "8a6e4b0c56d9f0e4f3c1b2a7d5e6f8091a2b3c4d5e6f708192a3b4c5d6e7f809"
    end
  end

  on_linux do
    on_intel do
      url "${ASSET_PREFIX}v1.13.0/${name}-Linux-x86_64"
      sha256 "59d8df8f74d5bdfaa57b236a4cbea8e6a7b9d0d934b2df22f7ae01b5aad84a2c"
    end
    on_arm do
      url "${ASSET_PREFIX}v1.13.0/${name}-Linux-aarch64"
      sha256 "3f1e2d4c5b6a79880716f5e4d3c2b1a09f8e7d6c5b4a39281706f5e4d3c2b1a0"
    end
  end
end
RB
  done
  cat >"$good/Casks/erebine-desktop.rb" <<RB
# SPDX-License-Identifier: MIT
cask "erebine-desktop" do
  version "1.10.1"
  sha256 "c43f26ba9189f3ab62f6e55537020e6164905d19d5c60eb7062624766662c111"
  url "${ASSET_PREFIX}v#{version}/Erebine-Desktop-v#{version}.dmg"
end
RB

  if check_tree "$good" >/dev/null; then
    echo "self-test ok   formulas at one version per platform, and a cask pinned elsewhere, pass"
  else
    echo "self-test FAIL the good fixture should pass"
    check_tree "$good" || true
    status=1
  fi

  # The last-block cases edit only the Linux aarch64 block: the range runs
  # from its url line to the stanza named.
  for case_name in no-license-stanza non-mit-license version-url-mismatch cask-no-version \
                   partial-pin foreign-host placeholder-sha no-spdx-header non-ascii \
                   last-block-version-mismatch last-block-unpinned last-block-partial-pin \
                   macos-intel-block-behind macos-intel-block-sha-differs; do
    local bad="$tmp/$case_name"
    cp -r "$good" "$bad"
    local f="$bad/Formula/erectl.rb" cask="$bad/Casks/erebine-desktop.rb"
    case "$case_name" in
      no-license-stanza)   sed -i '/^  license /d' "$f" ;;
      non-mit-license)     sed -i 's/license "MIT"/license "GPL-3.0-only"/' "$f" ;;
      version-url-mismatch)
        sed -i 's|v#{version}/Erebine-Desktop-v#{version}|v1.10.2/Erebine-Desktop-v1.10.2|' "$cask" ;;
      cask-no-version)     sed -i '/^  version /d' "$cask" ;;
      partial-pin)         sed -i 's|/v1.13.0/|/v1.10.2/|' "$f" ;;
      foreign-host)
        sed -i 's|https://github.com/Erebine/binaries|https://example.invalid/mirror|' "$f" ;;
      placeholder-sha)     sed -i '/Linux-aarch64/,/sha256/ s/sha256 ".*"/sha256 "TODO"/' "$f" ;;
      no-spdx-header)      sed -i '1d' "$f" ;;
      non-ascii)           printf '# Copyright \302\251 2026\n' >>"$f" ;;
      last-block-version-mismatch)
        sed -i '/Linux-aarch64/a\      version "1.13.1"' "$f" ;;
      last-block-unpinned)
        sed -i "/Linux-aarch64/,/sha256/ s/sha256 \".*\"/sha256 \"$UNPINNED_SHA\"/" "$f" ;;
      last-block-partial-pin) sed -i '/Linux-aarch64/ s|/v1.13.0/|/v1.13.1/|' "$f" ;;
      # The macOS on_intel block is the second Darwin-arm64 url in the file.
      macos-intel-block-behind)
        sed -i '/on_intel do/{n;/Darwin-arm64/ s|/v1.12.0/|/v1.11.0/|}' "$f" ;;
      macos-intel-block-sha-differs)
        sed -i '/on_intel do/{n;/Darwin-arm64/{n;s/sha256 "[0-9a-f]*"/sha256 "'"${UNPINNED_SHA//0/a}"'"/}}' "$f" ;;
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
