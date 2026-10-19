# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.6.0/erebine-eem-agent-Darwin-arm64"
      version "2.6.0"
      sha256 "e6f08312924e973091fe2a2f1f8f06c7872fbcedfa6f4fb9eb5239c62309aacf"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.6.0/erebine-eem-agent-Linux-x86_64"
    version "2.6.0"
    sha256 "81525f1e8d0d44e2e1b67b0d8e89f5e297f62639a6d01b8cfdb4226b6a8c4d74"
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
