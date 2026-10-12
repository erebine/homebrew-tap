# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.5.1/erectl-Darwin-arm64"
      version "2.5.1"
      sha256 "ae5b5c284e0ddbbc6ce5bb9bb3c5ffd494454ee30afa9b72ab56694e670a684e"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.5.1/erectl-Linux-x86_64"
    version "2.5.1"
    sha256 "ff4abdbb5d4639fabcdcb68899905b0d5bd48860d6035e9e464f3dc5dd9a1500"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
