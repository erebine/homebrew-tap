# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erectl-Darwin-arm64"
      version "2.2.1"
      sha256 "0ad95df9503443673a59be5a9ad35dbd650c6b437dae90f507caa46b484ab6b5"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erectl-Linux-x86_64"
    version "2.2.1"
    sha256 "2611df695d93f322378efba42a91358c51d370d1b81635edb4fc7ed59c026744"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
