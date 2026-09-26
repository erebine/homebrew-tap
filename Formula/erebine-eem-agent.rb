# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.3.0/erebine-eem-agent-Darwin-arm64"
      version "2.3.0"
      sha256 "5dbc4603a1ac14dd553619edb3e04665d5ed77be9f297c8c038b235634154148"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.3.0/erebine-eem-agent-Linux-x86_64"
    version "2.3.0"
    sha256 "40d7df03499101d90d06da0dd98c89dc65094ee99067135060b25f13cad78699"
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
