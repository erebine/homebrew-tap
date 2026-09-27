# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.1/erectl-Darwin-arm64"
      version "2.3.1"
      sha256 "d547505ed819e3341b79c3411a4013d3ad86777f1514d3622bee056bc70f2cfa"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.1/erectl-Linux-x86_64"
    version "2.3.1"
    sha256 "5991458e4397d982b0fd837a08dc010df087e736fa76a0cbfc3a9c79099020c3"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
