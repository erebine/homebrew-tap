# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  url "https://github.com/Erebine/binaries/releases/download/v1.13.0/erebine-eem-agent-Linux-x86_64"
  version "1.13.0"
  sha256 "06dee5e5f93b43f23a09b29627f0fb819986baaea12c27b0b0ca31974f15d505"
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
    bin.install Dir["erebine-eem-agent-*"].first => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem-agent", "--help"
  end
end
