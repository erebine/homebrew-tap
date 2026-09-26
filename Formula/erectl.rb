# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.0/erectl-Darwin-arm64"
      version "2.3.0"
      sha256 "759a4d2aa786bc0ab3cd541c1e9779eafedb19fde7a39801c8ef4e9f8c28867e"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.0/erectl-Linux-x86_64"
    version "2.3.0"
    sha256 "6319377b6b2a84d53fa3078a48f38baa82b165712c855c8096adce439c0662fd"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
