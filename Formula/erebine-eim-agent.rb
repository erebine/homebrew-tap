# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  url "https://github.com/Erebine/binaries/releases/download/v1.13.0/erebine-eim-agent-Linux-x86_64"
  version "1.13.0"
  sha256 "823451eecf4cabcd308233175f436f4e783ef29bc044a5b3562e315443e8e67a"
  license "MIT"

  # Erebine/binaries has shipped Linux x86_64 assets only since v1.10.2.
  # There is no Darwin binary and no Linux arm64 binary to install, so
  # refuse outright rather than leave users on a stale release or hand
  # them a binary their CPU cannot exec.
  depends_on arch: :x86_64
  depends_on :linux
  depends_on "zeromq"
  depends_on "zstd"

  def install
    bin.install Dir["erebine-eim-agent-*"].first => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim-agent", "--help"
  end
end
