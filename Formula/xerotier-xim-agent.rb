# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xim-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXimAgent < Formula
  desc "Xerotier XIM inference agent"
  homepage "https://xerotier.ai"
  version "0.0.1"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/xerotier-xim-agent-Darwin-arm64"
      sha256 "f583dbc58ddb56225a78184d5e8eb9a6d48729e0fe26a9a8e73388e10966a0f6"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/xerotier-xim-agent-Linux-x86_64"
    sha256 "8f3fb8c63c59da8541d2985300e5f1ca26746b5e4d6a533527def2be4242a7e2"
  end

  def install
    bin.install Dir["xerotier-xim-agent-*"].first => "xerotier-xim-agent"
  end

  test do
    system bin/"xerotier-xim-agent", "--help"
  end
end
