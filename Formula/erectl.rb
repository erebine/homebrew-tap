# SPDX-License-Identifier: MIT
# Prebuilt erectl binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class Erectl < Formula
  desc "Erebine command-line client"
  homepage "https://erebine.ai"
  url "https://github.com/Erebine/binaries/releases/download/v1.13.0/erectl-Linux-x86_64"
  version "1.13.0"
  sha256 "59d8df8f74d5bdfaa57b236a4cbea8e6a7b9d0d934b2df22f7ae01b5aad84a2c"
  license "MIT"

  # Erebine/binaries has shipped Linux x86_64 assets only since v1.10.2.
  # There is no Darwin binary and no Linux arm64 binary to install, so
  # refuse outright rather than leave users on a stale release or hand
  # them a binary their CPU cannot exec.
  depends_on arch: :x86_64
  depends_on :linux
  depends_on "zstd"

  def install
    bin.install Dir["erectl-*"].first => "erectl"
  end

  test do
    system bin/"erectl", "--help"
  end
end
