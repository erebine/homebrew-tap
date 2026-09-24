# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erectl-Darwin-arm64"
      version "1.10.0"
      sha256 "5326e39ed1047932c80b0e95c9637c98b8342e22752939ac4df9979d32b9f79b"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erectl-Linux-x86_64"
    version "2.0.0"
    sha256 "37bb5c0850859e90ce2c0ef7e18634f1a7ad3b4d4e9c7d8f4dfe348a34efd667"
  end

  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
