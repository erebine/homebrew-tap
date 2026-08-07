# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  version "1.3.0"
  license "MIT"

  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v1.3.0/erectl-Darwin-arm64"
      sha256 "ef71ff916a900fe597e0cfaa3dde7971593f05aadc502b170313f74c40888c5d"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v1.3.0/erectl-Linux-x86_64"
    sha256 "a3cb0d8ef7c1412b697c62364b3a8fa5a402c2824662a1ff8114bde64b0d6e44"
  end

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
