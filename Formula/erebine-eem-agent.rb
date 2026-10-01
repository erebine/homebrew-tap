# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.4.0/erebine-eem-agent-Darwin-arm64"
      version "2.4.0"
      sha256 "84579e60614190b07591f305b2cd6da2803d38f4a4fcbf37196fce959bb6f40f"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.4.0/erebine-eem-agent-Linux-x86_64"
    version "2.4.0"
    sha256 "af11f58b759fb2b28b4a7792ea6f2ee4c7155dd574feaa2d206a962a967a1c46"
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
