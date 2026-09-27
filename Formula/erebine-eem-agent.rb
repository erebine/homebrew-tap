# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.2/erebine-eem-agent-Darwin-arm64"
      version "2.3.2"
      sha256 "f26d701f1cd48a4e49dc46f9f9e28dda8b11baf0e8ab191108311e020aa96d2c"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.2/erebine-eem-agent-Linux-x86_64"
    version "2.3.2"
    sha256 "58f758b7370d67c04df86dd70c8b852af5b7fcd9ff6a824d4de65c31ce891705"
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
