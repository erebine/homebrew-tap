# SPDX-License-Identifier: MIT
# Prebuilt erebine-eem-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEemAgent < Formula
  desc "Erebine EEM execution agent"
  homepage "https://erebine.ai"
  version "1.3.0"
  license "MIT"

  depends_on "zeromq"
  depends_on "zstd"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v1.3.0/erebine-eem-agent-Darwin-arm64"
      sha256 "39850e83b4583d8f199d8a69d502765c45e9b87e8a7ba7ede993afac1bd16688"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v1.3.0/erebine-eem-agent-Linux-x86_64"
    sha256 "de593d5157202a6a80e0b6a47c9e2cf12caf56cfbd478bba617042d8c863c1c0"
  end

  def install
    bin.install Dir["erebine-eem-agent-*"].first => "erebine-eem-agent"
  end

  test do
    system bin/"erebine-eem-agent", "--help"
  end
end
