# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erebine-eem-agent-Darwin-arm64"
      version "2.2.1"
      sha256 "81fb1e173d4954f7a2c1f15a454d256b0de1ebffd8030222a4347b08fdcaeb7e"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erebine-eem-agent-Linux-x86_64"
    version "2.2.1"
    sha256 "82a3eb639a0ff6de92e7467238e2dc1f29d529416482053c05cff22bc20e1336"
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
