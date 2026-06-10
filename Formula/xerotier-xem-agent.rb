# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xem-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXemAgent < Formula
  desc "Xerotier XEM execution agent"
  homepage "https://xerotier.ai"
  version "0.0.1"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/xerotier-xem-agent-Darwin-arm64"
      sha256 "785362493f5d1fda25f10cec30243a25a2c1d482eeb4b7b4559439f692eb171a"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.1/xerotier-xem-agent-Linux-x86_64"
    sha256 "ebdc5076d58d910c39a55facba87dd5a03a47fe05210afdd37dc0b5d35401671"
  end

  def install
    bin.install Dir["xerotier-xem-agent-*"].first => "xerotier-xem-agent"
  end

  test do
    system bin/"xerotier-xem-agent", "--help"
  end
end
