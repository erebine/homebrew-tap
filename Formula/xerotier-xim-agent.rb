# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xim-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXimAgent < Formula
  desc "Xerotier XIM inference agent"
  homepage "https://xerotier.ai"
  version "0.0.0"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.0/xerotier-xim-agent-Darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.0/xerotier-xim-agent-Linux-x86_64"
    sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  end

  def install
    bin.install Dir["xerotier-xim-agent-*"].first => "xerotier-xim-agent"
  end

  test do
    system bin/"xerotier-xim-agent", "--help"
  end
end
