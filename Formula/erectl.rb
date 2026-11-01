# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erectl-Darwin-arm64"
      version "2.9.1"
      sha256 "f1f73990fede37204282b13bf0924f1d276c109325c90730617c995bb5f10054"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.9.1/erectl-Linux-x86_64"
    version "2.9.1"
    sha256 "acd0de971d905735d5ca58f8d09d63a5174b7b5a1cbbbb2e86f069cf791708ba"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
