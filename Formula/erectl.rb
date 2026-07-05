# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  version "0.3.13-1-gf93ede61a-2-gdb5d4a3ab"
  license "MIT"

  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/erectl-Darwin-arm64"
      sha256 "24e4f1c06747279dfd2c290c096a7bf4103110998a5b325d65abcc87fdbc49a4"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v0.3.13-1-gf93ede61a-2-gdb5d4a3ab/erectl-Linux-x86_64"
    sha256 "8de6b8259d084b53bbc3c9df2cb1adc126a865abff20489bc473f91af141bf4c"
  end

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
