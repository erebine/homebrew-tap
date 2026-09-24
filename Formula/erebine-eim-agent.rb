# SPDX-License-Identifier: MIT
# Prebuilt erebine-eim-agent binary from Erebine/binaries releases.
# Pin to the latest stable release with scripts/update-formulas.sh.
class ErebineEimAgent < Formula
  desc "Erebine EIM inference agent"
  homepage "https://erebine.ai"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erebine-eim-agent-Darwin-arm64"
      version "1.10.0"
      sha256 "26062988796e45c5e16e5cb46a220afcd72289b6f0bad58fdda092f6266ba598"
    end
  end

  on_linux do
    url "https://github.com/Erebine/binaries/releases/download/v2.2.1/erebine-eim-agent-Linux-x86_64"
    version "2.0.0"
    sha256 "0c6f229d2c4a34fd87ab05e7b285dc3be33090957222372dc2772eaaf3659b7b"
  end

  depends_on "zeromq"
  depends_on "zstd"

  def install
    bin.install Dir["erebine-eim-agent-*"].first => "erebine-eim-agent"
  end

  test do
    system bin/"erebine-eim-agent", "--help"
  end
end
