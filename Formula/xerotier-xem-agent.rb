# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xem-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXemAgent < Formula
  desc "Xerotier XEM execution agent"
  homepage "https://xerotier.ai"
  version "0.0.3"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/xerotier-xem-agent-Darwin-arm64"
      sha256 "d3b8e45067a7ab8a44d2aa686a6a0f0d9d4ab63df1b39253c56fa1bba96e160d"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.0.3/xerotier-xem-agent-Linux-x86_64"
    sha256 "6f0d25b6853b0dfacff447379fe8032d6922a9dea812e4bb23125f7fe1e5382b"
  end

  def install
    bin.install Dir["xerotier-xem-agent-*"].first => "xerotier-xem-agent"
  end

  test do
    system bin/"xerotier-xem-agent", "--help"
  end
end
