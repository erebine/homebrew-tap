# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.2/erectl-Darwin-arm64"
      version "2.3.2"
      sha256 "6a982e6c0a6f81eeac6d87766514c1fcde353868e3a4a1edc30118c36490f16c"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.2/erectl-Linux-x86_64"
    version "2.3.2"
    sha256 "ad2252aed733926353c5ef8ebd4ab4c4525bdc9d98c6be39c024161fd368eac5"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
