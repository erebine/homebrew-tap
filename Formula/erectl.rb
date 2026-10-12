# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.5.2/erectl-Darwin-arm64"
      version "2.5.2"
      sha256 "1bc9ada7ce1d185ad5aaf4906e43190039f11595d43acad8f5f3ed346a503c9d"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.5.2/erectl-Linux-x86_64"
    version "2.5.2"
    sha256 "33566252f1f2d4a260ad2d3e2682e339efd614ba72465a90e1d33b5690e9fa4d"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
