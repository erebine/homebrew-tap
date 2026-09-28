# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.4/erectl-Darwin-arm64"
      version "2.3.4"
      sha256 "bf9d970b6d6a33e3f9bdbe3f529e1c78faa05635d15440dacd06449b7aa8269c"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.4/erectl-Linux-x86_64"
    version "2.3.4"
    sha256 "e1dd8167d968538814a12a3b01e5920da11e48d4416a653f1dd4124ffdbd30a0"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
