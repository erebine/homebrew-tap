# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xim-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXimAgent < Formula
  desc "Xerotier XIM inference agent"
  homepage "https://xerotier.ai"
  version "0.0.3"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/xerotier-xim-agent-Darwin-arm64"
      sha256 "7daa8e2b5c3270ce74645e67d7b05da914cb3f01ab2d717567b2aec72f555f83"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/xerotier-xim-agent-Linux-x86_64"
    sha256 "6975efcc87e407eae3ad449a50921d42ae2bf45782f8d52e395a73b525057b9c"
  end

  def install
    bin.install Dir["xerotier-xim-agent-*"].first => "xerotier-xim-agent"
  end

  test do
    system bin/"xerotier-xim-agent", "--help"
  end
end
