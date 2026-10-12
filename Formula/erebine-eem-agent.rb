# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.5.1/erebine-eem-agent-Darwin-arm64"
      version "2.5.1"
      sha256 "84579e60614190b07591f305b2cd6da2803d38f4a4fcbf37196fce959bb6f40f"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.5.0/erebine-eem-agent-Linux-x86_64"
    version "2.5.0"
    sha256 "7449001be494a2e78a2b596ca2b610ed29d5a135232cb045d98d07c262ed6d73"
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
