# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xim-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXimAgent < Formula
  desc "Xerotier XIM inference agent"
  homepage "https://xerotier.ai"
  version "0.1.0"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.1.0/xerotier-xim-agent-Darwin-arm64"
      sha256 "7daa8e2b5c3270ce74645e67d7b05da914cb3f01ab2d717567b2aec72f555f83"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.1.0/xerotier-xim-agent-Linux-x86_64"
    sha256 "fe6fd1da65989de3b06ae63cce412e76bb0dcd1e48dbcb16f0cf9c2f2eb124ab"
  end

  def install
    bin.install Dir["xerotier-xim-agent-*"].first => "xerotier-xim-agent"
  end

  test do
    system bin/"xerotier-xim-agent", "--help"
  end
end
