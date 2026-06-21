# SPDX-License-Identifier: MIT
# Prebuilt xerotier-xem-agent binary from Xerotier/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class XerotierXemAgent < Formula
  desc "Xerotier XEM execution agent"
  homepage "https://xerotier.ai"
  version "0.1.0"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Xerotier/binaries/releases/download/v0.1.0/xerotier-xem-agent-Darwin-arm64"
      sha256 "cfd2ef66df3d0c4f942bd225f50ec7982d90c86368c4d75db18045788ff32d59"
    end
  end

  on_linux do
    url "https://github.com/Xerotier/binaries/releases/download/v0.1.0/xerotier-xem-agent-Linux-x86_64"
    sha256 "346699e677d4850bfa9dd5d93310aaa4703762ca4b9416decff9953ca3ef86b6"
  end

  def install
    bin.install Dir["xerotier-xem-agent-*"].first => "xerotier-xem-agent"
  end

  test do
    system bin/"xerotier-xem-agent", "--help"
  end
end
