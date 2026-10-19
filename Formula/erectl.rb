# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.6.0/erectl-Darwin-arm64"
      version "2.6.0"
      sha256 "8e6824ed37fa35962b435872756e52dd9ec3f2e33600769ff57e8ff9b7f138b2"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.6.0/erectl-Linux-x86_64"
    version "2.6.0"
    sha256 "a5c20fdf10ee66ad3982012bd43f323ebe7cf1f2d6914bf6d997cf6535d75cd8"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
