# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xem-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXemAgent < Formula
  desc "Xerotier XEM execution agent"
  homepage "https://xerotier.ai"
  version "0.3.9"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/xerotier-xem-agent-Darwin-arm64"
      sha256 "3dda01009aa181e6afaa12caa7162af3207417bbaa2f7cc60bc76d026481c67e"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.3.9/xerotier-xem-agent-Linux-x86_64"
    sha256 "332a1274e290866ada1eea18c400eb46186d06db38e1c8ab6f1563c3fb969a1e"
  end

  def install
    bin.install Dir["xerotier-xem-agent-*"].first => "xerotier-xem-agent"
  end

  test do
    system bin/"xerotier-xem-agent", "--help"
  end
end
