# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.5.2/erebine-eem-agent-Darwin-arm64"
      version "2.5.2"
      sha256 "d4680a0be690c6adc5bf52251bf25632a5996bca99f5d7b4c6f2cd9e5b03c5f7"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.5.2/erebine-eem-agent-Linux-x86_64"
    version "2.5.2"
    sha256 "26ba2039d46872deed51bb02ee65a24d16c5f21ccd6b576ef5e90c6d5b64ff42"
  end

  depends_on "zeromq"
  depends_on "zstd"

  def install
    bin.install Dir["erebine-eem-agent-*"].first => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem-agent", "--help"
  end
end
