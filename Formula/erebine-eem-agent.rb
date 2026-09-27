# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.1/erebine-eem-agent-Darwin-arm64"
      version "2.3.1"
      sha256 "a92bc93f4632364f61346c8ce6da791202f9ecc1f7f3fb894d643fcd359a64d9"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.1/erebine-eem-agent-Linux-x86_64"
    version "2.3.1"
    sha256 "85d5d88cdb80fef3a2f6a7202a12c3a33f3822872c35e01dd84edfaa663472e4"
  end

  depends_on "zeromq"
  depends_on "zstd"

  def install
    bin.install Dir["erebine-eem-agent-*"].first => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem-agent", "--help"
  end
end
