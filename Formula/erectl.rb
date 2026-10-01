# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.4.0/erectl-Darwin-arm64"
      version "2.4.0"
      sha256 "ae5b5c284e0ddbbc6ce5bb9bb3c5ffd494454ee30afa9b72ab56694e670a684e"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.4.0/erectl-Linux-x86_64"
    version "2.4.0"
    sha256 "899b3b6e91291112cd0061fa10722845553b0b988362985e71b857173f25e078"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
