# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.2.0/erebine-eem-agent-Darwin-arm64"
      version "1.10.0"
      sha256 "50d9094b4d10bac9b5d30bc08fda75cd93faef9306ee3946661df7f64c068c70"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.2.0/erebine-eem-agent-Linux-x86_64"
    version "2.0.0"
    sha256 "48110d81693369a101d533b24124b7bcba185ac08111fd1465e0d0892c7b7b93"
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
